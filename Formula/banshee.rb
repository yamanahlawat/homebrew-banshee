class Banshee < Formula
  desc "Offline local voice daemon: push-to-talk dictation and spoken status feedback for AI coding agents"
  homepage "https://github.com/yamanahlawat/banshee"
  version "0.7.0"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/yamanahlawat/banshee/releases/download/v0.7.0/banshee-aarch64-apple-darwin.tar.xz"
    sha256 "db03570341fbdba23c9b207e7bbbb3f0816c6f16f42d7a833024f6b2f8a5d93a"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/yamanahlawat/banshee/releases/download/v0.7.0/banshee-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "6cf52e31f7e4fca5cc96ce1789b916bf66869e0bba130da88664116121028d89"
    end
    if Hardware::CPU.intel?
      url "https://github.com/yamanahlawat/banshee/releases/download/v0.7.0/banshee-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "8f710feb48080edac871e7316881229337604128474d25fd1712eb85ba546bea"
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
    bin.install "banshee", "banshee-mcp-shim" if OS.mac? && Hardware::CPU.arm?
    bin.install "banshee", "banshee-mcp-shim" if OS.linux? && Hardware::CPU.arm?
    bin.install "banshee", "banshee-mcp-shim" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
