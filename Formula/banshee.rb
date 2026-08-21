class Banshee < Formula
  desc "Offline local voice daemon: push-to-talk dictation and spoken status feedback for AI coding agents"
  homepage "https://github.com/yamanahlawat/banshee"
  version "0.8.0"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/yamanahlawat/banshee/releases/download/v0.8.0/banshee-aarch64-apple-darwin.tar.xz"
    sha256 "fa2fa4192679c546580101e0b0bfc3714d12a3f60651f12136e5e7e5e82b904a"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/yamanahlawat/banshee/releases/download/v0.8.0/banshee-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "fa12ee19fbe2d42efcff765f9ce013407fe1089248efedb75b11464a1730ba21"
    end
    if Hardware::CPU.intel?
      url "https://github.com/yamanahlawat/banshee/releases/download/v0.8.0/banshee-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "d19b243346ff341d581a87eb39a433279535a96ddb50c0e78ba11fd094fba90d"
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
      bin.install "banshee", "banshee-mcp-shim"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "banshee", "banshee-mcp-shim"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "banshee", "banshee-mcp-shim"
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
