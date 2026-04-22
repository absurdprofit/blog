set unstable

MDBOOK_VERSION := env("MDBOOK_VERSION", "0.4.36")
rust_install := if which("rustup") != "" {
  "echo ✅ Rust already installed"
} else if os() == "windows" {
  "echo ❌ Rust installation on Windows is not supported by this script. Please update the justfile to include the appropriate installation command for Windows."
} else {
  "curl --proto '=https' --tlsv1.2 https://sh.rustup.rs -sSf -y | sh"
}

install:
  @{{rust_install}}
  @rustup update
  @cargo install --version {{MDBOOK_VERSION}} mdbook

serve: install
  @mdbook serve --open

build: install
  @mdbook build