class Stelyph < Formula
  desc "A single static binary AT Protocol PDS (Personal Data Server) for self-hosted Bluesky federation"
  homepage "https://github.com/Spirallex/rust-pds"
  version "0.1.0-alpha.3"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/Spirallex/rust-pds/releases/download/v0.1.0-alpha.3/stelyph-aarch64-apple-darwin.tar.xz"
    sha256 "bdae9973d2fd4cbb5e26344c3ca213339cffb62501f31e81cea2f7e912fbb96e"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/Spirallex/rust-pds/releases/download/v0.1.0-alpha.3/stelyph-aarch64-unknown-linux-musl.tar.xz"
      sha256 "5d4433ae898d7f7025a36066ef703f0d305237931ff21654ac92fa3d675d1686"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Spirallex/rust-pds/releases/download/v0.1.0-alpha.3/stelyph-x86_64-unknown-linux-musl.tar.xz"
      sha256 "ce67c1ebd2aaa9f714f10cffddf7a63bb91b9eff0d054b469f375c9759cca54c"
    end
  end
  license "PolyForm-Noncommercial-1.0.0"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":               {},
    "aarch64-unknown-linux-gnu":          {},
    "aarch64-unknown-linux-musl-dynamic": {},
    "aarch64-unknown-linux-musl-static":  {},
    "x86_64-unknown-linux-gnu":           {},
    "x86_64-unknown-linux-musl-dynamic":  {},
    "x86_64-unknown-linux-musl-static":   {},
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
    bin.install "firehose-tail", "stelyph" if OS.mac? && Hardware::CPU.arm?
    bin.install "firehose-tail", "stelyph" if OS.linux? && Hardware::CPU.arm?
    bin.install "firehose-tail", "stelyph" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
