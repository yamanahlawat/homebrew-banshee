class Banshee < Formula
  desc "Offline local voice daemon: push-to-talk dictation and spoken status feedback for AI coding agents"
  homepage "https://github.com/yamanahlawat/banshee"
  version "0.16.3"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/yamanahlawat/banshee/releases/download/v0.16.3/banshee-aarch64-apple-darwin.tar.xz"
    sha256 "3f1abaa438eb22d519a05d771ad6d65ac1099028a34d69fa65481976fb0d9877"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/yamanahlawat/banshee/releases/download/v0.16.3/banshee-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "84b1bfcf1a8df24d1a321505307f98e342b3e5cb3791f96c7ab669904fddde1f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/yamanahlawat/banshee/releases/download/v0.16.3/banshee-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "29245da4fe5781a5693863c2d64645a650c1c755f7b8a5ed14e47d8cb6c4bbde"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    if OS.mac? && Hardware::CPU.arm?
      bin.install "banshee", "banshee-mcp-shim", "banshee-tray"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "banshee", "banshee-mcp-shim", "banshee-tray"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "banshee", "banshee-mcp-shim", "banshee-tray"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
