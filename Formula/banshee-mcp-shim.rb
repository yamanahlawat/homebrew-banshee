class BansheeMcpShim < Formula
  desc "MCP stdio shim bridging any Model Context Protocol client to the Banshee voice daemon"
  homepage "https://github.com/yamanahlawat/banshee"
  version "0.4.0"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/yamanahlawat/banshee/releases/download/v0.4.0/banshee-mcp-shim-aarch64-apple-darwin.tar.xz"
    sha256 "649e87d7e1f0fe919973faa54364781d1da96d3155cd2e1e77b57a030691f68f"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/yamanahlawat/banshee/releases/download/v0.4.0/banshee-mcp-shim-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "5200ba40facd4d41af312ce4485b622afb81c1710f07258d8ee1c0b7eedd88ac"
    end
    if Hardware::CPU.intel?
      url "https://github.com/yamanahlawat/banshee/releases/download/v0.4.0/banshee-mcp-shim-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "2be618947fb13b061383f9508b989654175373187e0257cc0be1227a0d66b21c"
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
    bin.install "banshee-mcp-shim" if OS.mac? && Hardware::CPU.arm?
    bin.install "banshee-mcp-shim" if OS.linux? && Hardware::CPU.arm?
    bin.install "banshee-mcp-shim" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
