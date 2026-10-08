class Banshee < Formula
  desc "Offline local voice daemon: push-to-talk dictation and spoken status feedback for AI coding agents"
  homepage "https://github.com/yamanahlawat/banshee"
  version "0.16.2"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/yamanahlawat/banshee/releases/download/v0.16.2/banshee-aarch64-apple-darwin.tar.xz"
    sha256 "83ffe68faf04756afe358a1f2930c229812d2568b24404956e76f075435749c7"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/yamanahlawat/banshee/releases/download/v0.16.2/banshee-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "32f4154ba7cc21e1fdc0304892a91c0c103760b95cd3c249ec95732950722be3"
    end
    if Hardware::CPU.intel?
      url "https://github.com/yamanahlawat/banshee/releases/download/v0.16.2/banshee-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "73b887e84dbade3f7b5a2bf41a90238bb8078c66aac486e84529eb7930fca125"
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
