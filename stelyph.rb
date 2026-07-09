class Stelyph < Formula
  desc "A single static binary AT Protocol PDS (Personal Data Server) for self-hosted Bluesky federation"
  homepage "https://github.com/Spirallex/rust-pds"
  version "0.1.0-alpha.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/Spirallex/rust-pds/releases/download/v0.1.0-alpha.1/stelyph-aarch64-apple-darwin.tar.xz"
      sha256 "7e62e6eada1fcbf0b296c93112a5472d286395547e76e930e00551d35b961c2d"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/Spirallex/rust-pds/releases/download/v0.1.0-alpha.1/stelyph-aarch64-unknown-linux-musl.tar.xz"
      sha256 "6f8624557247db480bc38c6941460a919f0abf04f12ec4cb94482b728c8afe9c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Spirallex/rust-pds/releases/download/v0.1.0-alpha.1/stelyph-x86_64-unknown-linux-musl.tar.xz"
      sha256 "33aff1b348de36a7e3ae4a16ce5df98f89e8b81df1ad0dee776f638f79d011c3"
    end
  end
  license "PolyForm-Noncommercial-1.0.0"

  BINARY_ALIASES = {
    "aarch64-apple-darwin": {},
    "aarch64-unknown-linux-gnu": {},
    "aarch64-unknown-linux-musl-dynamic": {},
    "aarch64-unknown-linux-musl-static": {},
    "x86_64-unknown-linux-gnu": {},
    "x86_64-unknown-linux-musl-dynamic": {},
    "x86_64-unknown-linux-musl-static": {}
  }

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
      bin.install "firehose-tail", "stelyph"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "firehose-tail", "stelyph"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "firehose-tail", "stelyph"
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
