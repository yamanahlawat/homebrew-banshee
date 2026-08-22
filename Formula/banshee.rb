class Banshee < Formula
  desc "Offline local voice daemon: push-to-talk dictation and spoken status feedback for AI coding agents"
  homepage "https://github.com/yamanahlawat/banshee"
  version "0.9.0"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/yamanahlawat/banshee/releases/download/v0.9.0/banshee-aarch64-apple-darwin.tar.xz"
    sha256 "362a4e0c44e00ac3fce63c9aac950cfd5cd06102e62c4590704f746e10d50543"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/yamanahlawat/banshee/releases/download/v0.9.0/banshee-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "50a586aaf4b83fe4cb8c4e8b267f9b9573e421dc7615c1309b5e3330c4af8ac0"
    end
    if Hardware::CPU.intel?
      url "https://github.com/yamanahlawat/banshee/releases/download/v0.9.0/banshee-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "47fd878506ffae25e54cc02b5a84c00c82bdbf8304605f01458b08a530db327d"
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
