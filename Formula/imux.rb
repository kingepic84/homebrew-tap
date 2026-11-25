class Imux < Formula
  desc "Terminal multiplexer with images in the scrollback"
  homepage "https://imux.cc"
  version "0.3.0"
  license "GPL-3.0-or-later"

  on_macos do
    on_arm do
      url "https://git.kingepic84.page/kingepic84/imux/releases/download/v#{version}/imux-aarch64-apple-darwin.tar.gz"
      sha256 "80a96d68fe453cd0b92ee4082b7bf028e582c1ae39d29040fe5511c35454ea14"
    end
    on_intel do
      url "https://git.kingepic84.page/kingepic84/imux/releases/download/v#{version}/imux-x86_64-apple-darwin.tar.gz"
      sha256 "501fb21dd949d848705791e939a3675f4301b8558b32ff201836dfc1e02a6188"
    end
  end

  on_linux do
    on_arm do
      url "https://git.kingepic84.page/kingepic84/imux/releases/download/v#{version}/imux-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "9374c21bbe187db762ff9e77068cba5ec42692392e61549e667bd1505731dcc3"
    end
    on_intel do
      url "https://git.kingepic84.page/kingepic84/imux/releases/download/v#{version}/imux-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "f2dd8368badff199b1addc09cdbfe86f2b75be0829b869750cd8216942159dfb"
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
