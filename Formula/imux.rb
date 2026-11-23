class Imux < Formula
  desc "Terminal multiplexer with images in the scrollback"
  homepage "https://imux.cc"
  version "0.1.0"
  license "GPL-3.0-or-later"

  on_macos do
    on_arm do
      url "https://git.kingepic84.page/kingepic84/imux/releases/download/v#{version}/imux-aarch64-apple-darwin.tar.gz"
      sha256 "603d1c4ea7375218b63f657c1563c912b7881a129bf3bbc2eaac3d637976c888"
    end
    on_intel do
      url "https://git.kingepic84.page/kingepic84/imux/releases/download/v#{version}/imux-x86_64-apple-darwin.tar.gz"
      sha256 "5056a591bfd1a4eba2f2bbad20ac2a76e60641dd0f0389c70c013955992af2ce"
    end
  end

  on_linux do
    on_arm do
      url "https://git.kingepic84.page/kingepic84/imux/releases/download/v#{version}/imux-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "72b6aa017b4c6d3d525857d9ee2d1a79db0886ba8330a364ada5ae73655c3565"
    end
    on_intel do
      url "https://git.kingepic84.page/kingepic84/imux/releases/download/v#{version}/imux-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "8da38c3d2972f14d7744a55908423b35d751d899780f048dee56c2c567f7af85"
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
