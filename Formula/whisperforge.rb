class Whisperforge < Formula
  desc "Fast GPU-accelerated speech-to-text CLI with streaming, quantization, speaker diarization, and multilingual support. Includes model conversion from HuggingFace safetensors."
  homepage "https://github.com/bevsxyz/WhisperForge"
  version "0.5.5"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/bevsxyz/WhisperForge/releases/download/v0.5.5/whisperforge-aarch64-apple-darwin.tar.xz"
    sha256 "050d8231a29d8cfc2dd351c7fab3f8ee4962ccdef495e991c1354e68f2c3db50"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/bevsxyz/WhisperForge/releases/download/v0.5.5/whisperforge-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "47cba08a4b0abec7c942512b42d71e656f63e9f0135cbfe30e8b939c43ab4681"
    end
    if Hardware::CPU.intel?
      url "https://github.com/bevsxyz/WhisperForge/releases/download/v0.5.5/whisperforge-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "350dce307cdfb34e59f4217080cd42a6b3116c8f35124e0b4ddbc29860551b03"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-pc-windows-gnu":     {},
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
    bin.install "wforge" if OS.mac? && Hardware::CPU.arm?
    bin.install "wforge" if OS.linux? && Hardware::CPU.arm?
    bin.install "wforge" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
