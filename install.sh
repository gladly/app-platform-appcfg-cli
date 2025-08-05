#!/bin/bash

# appcfg installation script
# Usage: curl -fsSL https://raw.githubusercontent.com/gladly/app-platform-appcfg-cli/main/install.sh | bash

set -e

# Configuration
REPO="gladly/app-platform-appcfg-cli"
BINARY_NAME="appcfg"
INSTALL_DIR="${HOME}/.local/bin"

# Colors for output (check if stdout is a terminal)
if [ -t 1 ]; then
    RED='\033[0;31m'
    GREEN='\033[0;32m'
    YELLOW='\033[1;33m'
    BLUE='\033[0;34m'
    NC='\033[0m' # No Color
else
    RED=''
    GREEN=''
    YELLOW=''
    BLUE=''
    NC=''
fi

# Logging functions
log_info() {
    printf "${BLUE}INFO:${NC} %s\n" "$1"
}

log_success() {
    printf "${GREEN}SUCCESS:${NC} %s\n" "$1"
}

log_warn() {
    printf "${YELLOW}WARNING:${NC} %s\n" "$1"
}

log_error() {
    printf "${RED}ERROR:${NC} %s\n" "$1" >&2
}

# Detect platform and architecture
detect_platform() {
    local platform
    local arch

    # Detect OS
    case "$(uname -s)" in
        Darwin*)
            platform="mac"
            ;;
        Linux*)
            platform="linux"
            ;;
        *)
            log_error "Unsupported operating system: $(uname -s). For Windows, use the PowerShell script instead."
            exit 1
            ;;
    esac

    # Detect architecture
    case "$(uname -m)" in
        x86_64|amd64)
            arch="intel"
            ;;
        arm64|aarch64)
            arch="apple"
            ;;
        *)
            log_error "Unsupported architecture: $(uname -m)"
            exit 1
            ;;
    esac

    # Construct platform string
    if [[ "$platform" == "mac" ]]; then
        PLATFORM_STRING="${platform}-${arch}"
    elif [[ "$platform" == "linux" ]]; then
        PLATFORM_STRING="${platform}-${arch}"
    else
        PLATFORM_STRING="${platform}"
    fi

    
    log_info "Detected platform: $PLATFORM_STRING"
}

# Get the latest release version from GitHub API
get_latest_version() {
    log_info "Fetching latest release version..."
    
    local api_url="https://api.github.com/repos/${REPO}/releases/latest"
    local version
    
    version=$(curl -fsSL "$api_url" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')
    
    if [[ -z "$version" ]]; then
        log_error "Failed to fetch latest version"
        exit 1
    fi
    
    # Remove 'v' prefix if present
    version=${version#v}
    
    VERSION="$version"
    log_info "Latest version: $VERSION"
}

# Download and extract the binary
download_and_install() {
    local filename="${BINARY_NAME}-${VERSION}-${PLATFORM_STRING}.zip"
    local download_url="https://github.com/${REPO}/releases/download/v${VERSION}/${filename}"
    local temp_dir
    
    temp_dir=$(mktemp -d)
    local temp_file="${temp_dir}/${filename}"
    
    log_info "Downloading appcfg ${VERSION} for ${PLATFORM_STRING}..."
    log_info "URL: $download_url"
    
    # Download the file
    if ! curl -fsSL -o "$temp_file" "$download_url"; then
        log_error "Failed to download $filename"
        rm -rf "$temp_dir"
        exit 1
    fi
    
    # Create install directory
    mkdir -p "$INSTALL_DIR"
    
    # Extract the binary
    log_info "Extracting binary..."
    if command -v unzip >/dev/null 2>&1; then
        if ! unzip -q "$temp_file" -d "$temp_dir"; then
            log_error "Failed to extract $filename"
            rm -rf "$temp_dir"
            exit 1
        fi
    else
        log_error "unzip is not available. Please install unzip."
        rm -rf "$temp_dir"
        exit 1
    fi
    
    # Move binary to install directory
    local binary_path="${temp_dir}/${BINARY_NAME}"
    local install_path="${INSTALL_DIR}/${BINARY_NAME}"
    
    if [[ ! -f "$binary_path" ]]; then
        log_error "Binary not found in archive: $binary_path"
        rm -rf "$temp_dir"
        exit 1
    fi
    
    mv "$binary_path" "$install_path"
    chmod +x "$install_path"
    
    # Clean up
    rm -rf "$temp_dir"
    
    log_success "appcfg installed to $install_path"
}

# Check if install directory is in PATH
check_path() {
    if [[ ":$PATH:" != *":$INSTALL_DIR:"* ]]; then
        log_warn "Install directory $INSTALL_DIR is not in your PATH"
        log_info "Add the following line to your shell profile (~/.bashrc, ~/.zshrc, etc.):"
        echo "export PATH=\"\$PATH:$INSTALL_DIR\""
        log_info "Then reload your shell or run: source ~/.bashrc (or ~/.zshrc)"
    fi
}

# Install shell completions
install_completions() {
    local binary_path="${INSTALL_DIR}/${BINARY_NAME}"
    
    # Detect shell
    local shell_name
    if [[ -n "$ZSH_VERSION" ]]; then
        shell_name="zsh"
    elif [[ -n "$BASH_VERSION" ]]; then
        shell_name="bash"
    else
        # Try to detect from $SHELL
        case "$SHELL" in
            */zsh) shell_name="zsh" ;;
            */bash) shell_name="bash" ;;
            */fish) shell_name="fish" ;;
            *) 
                log_info "Could not detect shell type, skipping completions"
                return
                ;;
        esac
    fi
    
    log_info "Installing $shell_name completions..."
    
    case "$shell_name" in
        zsh)
            local completion_dir
            if [[ "$OSTYPE" == "darwin"* ]] && command -v brew >/dev/null 2>&1; then
                # macOS with Homebrew
                completion_dir="$(brew --prefix)/share/zsh/site-functions"
            else
                # Linux or macOS without Homebrew
                completion_dir="${HOME}/.local/share/zsh/site-functions"
                # Add to fpath if not already there
                if [[ -f "${HOME}/.zshrc" ]]; then
                    if ! grep -q "fpath.*${completion_dir}" "${HOME}/.zshrc" 2>/dev/null; then
                        echo "" >> "${HOME}/.zshrc"
                        echo "# appcfg completions" >> "${HOME}/.zshrc"
                        echo "fpath=(${completion_dir} \$fpath)" >> "${HOME}/.zshrc"
                        echo "autoload -U compinit; compinit" >> "${HOME}/.zshrc"
                    fi
                fi
            fi
            
            mkdir -p "$completion_dir"
            if "$binary_path" completion zsh > "${completion_dir}/_appcfg" 2>/dev/null; then
                log_success "Zsh completions installed to ${completion_dir}/_appcfg"
                log_info "Restart your shell or run 'source ~/.zshrc' to enable completions"
            else
                log_warn "Failed to install zsh completions"
            fi
            ;;
        bash)
            local completion_file="${HOME}/.local/share/bash-completion/completions/appcfg"
            mkdir -p "$(dirname "$completion_file")"
            if "$binary_path" completion bash > "$completion_file" 2>/dev/null; then
                log_success "Bash completions installed to $completion_file"
                log_info "You may need to add this to your ~/.bashrc:"
                echo "source ~/.local/share/bash-completion/completions/appcfg"
            else
                log_warn "Failed to install bash completions"
            fi
            ;;
        fish)
            local completion_dir="${HOME}/.config/fish/completions"
            mkdir -p "$completion_dir"
            if "$binary_path" completion fish > "${completion_dir}/appcfg.fish" 2>/dev/null; then
                log_success "Fish completions installed to ${completion_dir}/appcfg.fish"
            else
                log_warn "Failed to install fish completions"
            fi
            ;;
    esac
}

# Verify installation
verify_installation() {
    local binary_path="${INSTALL_DIR}/${BINARY_NAME}"
    
    if [[ -x "$binary_path" ]]; then
        log_info "Verifying installation..."
        if "$binary_path" --version >/dev/null 2>&1; then
            local installed_version
            installed_version=$("$binary_path" --version 2>/dev/null | head -n1 || echo "unknown")
            log_success "appcfg is installed and working! (${installed_version})"
        else
            log_warn "appcfg is installed but may not be working correctly"
        fi
    else
        log_error "Installation verification failed"
        exit 1
    fi
}

main() {
    log_info "Installing appcfg CLI tool..."
    
    # Check dependencies
    if ! command -v unzip >/dev/null 2>&1; then
        log_warn "unzip is not installed. Please install it first."
        case "$(uname -s)" in
            Darwin*)
                log_info "On macOS: brew install unzip"
                ;;
            Linux*)
                log_info "On Ubuntu/Debian: sudo apt-get install unzip"
                log_info "On CentOS/RHEL: sudo yum install unzip"
                ;;
        esac
        exit 1
    fi
    
    detect_platform
    get_latest_version
    download_and_install
    check_path
    verify_installation
    install_completions
    
    log_success "Installation complete!"
    log_info "Run 'appcfg --help' to get started."
}

# Handle script interruption
trap 'log_error "Installation interrupted"; exit 1' INT TERM

# Run main function
main "$@"