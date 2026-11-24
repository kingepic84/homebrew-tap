class Imux < Formula
  desc "Terminal multiplexer with images in the scrollback"
  homepage "https://imux.cc"
  version "0.2.0"
  license "GPL-3.0-or-later"

  on_macos do
    on_arm do
      url "https://git.kingepic84.page/kingepic84/imux/releases/download/v#{version}/imux-aarch64-apple-darwin.tar.gz"
      sha256 "9d6f518bda0693e64356e7450aa3cc9f729f67278b056e9e21f6e0bee3e9e20c"
    end
    on_intel do
      url "https://git.kingepic84.page/kingepic84/imux/releases/download/v#{version}/imux-x86_64-apple-darwin.tar.gz"
      sha256 "44e4cd950a75f0530e35eb3b257c8fbf865bb2f9792f8a9b343cf6774b9ec587"
    end
  end

  on_linux do
    on_arm do
      url "https://git.kingepic84.page/kingepic84/imux/releases/download/v#{version}/imux-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "1b58e584cbe1ba18be83bd4252b1a56c7e8a664d7e033b9e0e5bb79068d4c6dd"
    end
    on_intel do
      url "https://git.kingepic84.page/kingepic84/imux/releases/download/v#{version}/imux-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "a2e38c33e2a97b707a433a733375efb13e840fe96d9ec2059be06333c05cbd36"
    end
  end

  def install
    bin.install "imux"
    # The manpage is built into the binary; write it where Homebrew links man pages from.
    system bin/"imux", "setup", "--no-skill", "--no-shell", "--man-dir", man
  end

  def caveats
    <<~EOS
      Run this once to install the agent skill and to set up your shell:
        imux setup
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/imux version")
    system bin/"imux", "setup", "--no-shell", "--man-dir", testpath/"share", "--skill-path", testpath/"skill/SKILL.md"
    assert_path_exists testpath/"share/man1/imux.1"
    assert_path_exists testpath/"skill/SKILL.md"
  end
end
