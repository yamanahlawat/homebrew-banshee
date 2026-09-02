class Banshee < Formula
  desc "Offline local voice daemon: push-to-talk dictation and spoken status feedback for AI coding agents"
  homepage "https://github.com/yamanahlawat/banshee"
  version "0.12.0"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/yamanahlawat/banshee/releases/download/v0.12.0/banshee-aarch64-apple-darwin.tar.xz"
    sha256 "f2d29fd4d330052b3c92e5a6740380b46b3a0b1e4cc7c2ea202b23be545e4a6b"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/yamanahlawat/banshee/releases/download/v0.12.0/banshee-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "0dfbc3614cb25aaf215fcde0d0d808b6313e68755226a02971304dad525cbb46"
    end
    if Hardware::CPU.intel?
      url "https://github.com/yamanahlawat/banshee/releases/download/v0.12.0/banshee-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "b6c510203a2b621ea008e74fb4dd7cb4415a6919edd48942e69bf7fe1f4adc8d"
    end
  end
  license any_of: ["MIT", "Apache-2.0"]

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
