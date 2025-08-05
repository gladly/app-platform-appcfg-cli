# appcfg installation script for Windows PowerShell
# Usage: irm https://raw.githubusercontent.com/gladly/app-platform-appcfg-cli/main/install.ps1 | iex

param(
    [string]$InstallDir
)

# Set default install directory if not provided
if (-not $InstallDir) {
    $InstallDir = "$env:LOCALAPPDATA\Programs\appcfg"
}

# Configuration
$Repo = "gladly/app-platform-appcfg-cli"
$BinaryName = "appcfg.exe"

# Logging functions
function Write-Info {
    param([string]$Message)
    Write-Host "INFO: $Message" -ForegroundColor Blue
}

function Write-Success {
    param([string]$Message)
    Write-Host "SUCCESS: $Message" -ForegroundColor Green
}

function Write-Warning {
    param([string]$Message)
    Write-Host "WARNING: $Message" -ForegroundColor Yellow
}

function Write-ErrorMsg {
    param([string]$Message)
    Write-Host "ERROR: $Message" -ForegroundColor Red
}

function Get-LatestVersion {
    Write-Info "Fetching latest release version..."
    
    try {
        $apiUrl = "https://api.github.com/repos/$Repo/releases/latest"
        $response = Invoke-RestMethod -Uri $apiUrl -ErrorAction Stop
        $version = $response.tag_name -replace '^v', ''
        
        Write-Info "Latest version: $version"
        return $version
    }
    catch {
        Write-ErrorMsg "Failed to fetch latest version: $($_.Exception.Message)"
        exit 1
    }
}

function Install-Appcfg {
    param([string]$Version)
    
    $filename = "appcfg-$Version-win.zip"
    $downloadUrl = "https://github.com/$Repo/releases/download/v$Version/$filename"
    
    Write-Info "Downloading appcfg $Version for Windows..."
    Write-Info "URL: $downloadUrl"
    
    # Create temporary directory
    $tempDir = Join-Path $env:TEMP "appcfg-install-$(Get-Random)"
    $tempFile = Join-Path $tempDir $filename
    
    try {
        New-Item -ItemType Directory -Path $tempDir -Force | Out-Null
        
        # Download the file
        Invoke-WebRequest -Uri $downloadUrl -OutFile $tempFile -ErrorAction Stop
        
        # Extract the archive
        Write-Info "Extracting binary..."
        Expand-Archive -Path $tempFile -DestinationPath $tempDir -Force
        
        # Create install directory
        New-Item -ItemType Directory -Path $InstallDir -Force | Out-Null
        
        # Move binary to install directory
        $binaryPath = Join-Path $tempDir $BinaryName
        $installPath = Join-Path $InstallDir $BinaryName
        
        if (Test-Path $binaryPath) {
            Move-Item -Path $binaryPath -Destination $installPath -Force
            Write-Success "appcfg installed to $installPath"
        }
        else {
            Write-ErrorMsg "Binary not found in archive: $binaryPath"
            exit 1
        }
    }
    catch {
        Write-ErrorMsg "Failed to download or extract: $($_.Exception.Message)"
        exit 1
    }
    finally {
        # Clean up
        if (Test-Path $tempDir) {
            Remove-Item -Path $tempDir -Recurse -Force
        }
    }
}

function Test-Installation {
    $installPath = Join-Path $InstallDir $BinaryName
    
    if (Test-Path $installPath) {
        Write-Info "Verifying installation..."
        try {
            $versionOutput = & $installPath --version 2>$null
            Write-Success "appcfg is installed and working! ($versionOutput)"
        }
        catch {
            Write-Warning "appcfg is installed but may not be working correctly"
        }
    }
    else {
        Write-ErrorMsg "Installation verification failed"
        exit 1
    }
}

function Add-ToPath {
    # Check if install directory is in PATH
    $currentPath = [Environment]::GetEnvironmentVariable("Path", "User")
    
    if ($currentPath -notlike "*$InstallDir*") {
        Write-Info "Adding $InstallDir to user PATH..."
        try {
            $newPath = "$currentPath;$InstallDir"
            [Environment]::SetEnvironmentVariable("Path", $newPath, "User")
            Write-Success "Added to PATH. Restart your terminal or run: refreshenv"
        }
        catch {
            Write-Warning "Failed to add to PATH automatically"
            Write-Info "Please manually add $InstallDir to your PATH environment variable"
        }
    }
}

function Install-Completions {
    Write-Info "Installing PowerShell completions..."
    
    $installPath = Join-Path $InstallDir $BinaryName
    $profileDir = Split-Path $PROFILE -Parent
    $completionFile = Join-Path $profileDir "appcfg-completion.ps1"
    
    try {
        # Create profile directory if it doesn't exist
        if (!(Test-Path $profileDir)) {
            New-Item -ItemType Directory -Path $profileDir -Force | Out-Null
        }
        
        # Generate completion script
        $completionScript = & $installPath completion powershell 2>$null
        
        if ($completionScript) {
            $completionScript | Out-File -FilePath $completionFile -Encoding UTF8
            
            # Add to PowerShell profile if it exists
            if (Test-Path $PROFILE) {
                $sourceCommand = ". `"$completionFile`""
                $profileContent = Get-Content $PROFILE -Raw -ErrorAction SilentlyContinue
                
                if ($profileContent -notlike "*$completionFile*") {
                    Add-Content -Path $PROFILE -Value "`n# appcfg completions`n$sourceCommand"
                    Write-Success "PowerShell completions installed and added to profile"
                    Write-Info "Restart PowerShell to enable completions"
                }
                else {
                    Write-Success "PowerShell completions updated"
                }
            }
            else {
                Write-Success "PowerShell completions installed to $completionFile"
                Write-Info "Add this to your PowerShell profile to enable completions:"
                Write-Host ". `"$completionFile`"" -ForegroundColor Cyan
            }
        }
        else {
            Write-Warning "Failed to generate PowerShell completions"
        }
    }
    catch {
        Write-Warning "Failed to install PowerShell completions: $($_.Exception.Message)"
    }
}

# Main execution
function Main {
    Write-Info "Installing appcfg CLI tool..."
    
    # Check if running in PowerShell (not PowerShell ISE or other hosts)
    if ($Host.Name -eq "ConsoleHost" -or $Host.Name -eq "Visual Studio Code Host") {
        # Proceed with installation
    }
    else {
        Write-Warning "This script is optimized for PowerShell console. Some features may not work correctly."
    }
    
    $version = Get-LatestVersion
    Install-Appcfg -Version $version
    Add-ToPath
    Test-Installation
    Install-Completions
    
    Write-Success "Installation complete!"
    Write-Info "Run 'appcfg --help' to get started."
    Write-Info "You may need to restart your terminal for PATH changes to take effect."
}

# Handle script interruption
trap {
    Write-ErrorMsg "Installation interrupted"
    exit 1
}

# Run main function
Main