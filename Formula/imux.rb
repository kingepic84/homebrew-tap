class Imux < Formula
  desc "Terminal multiplexer with images in the scrollback"
  homepage "https://imux.cc"
  version "0.2.1"
  license "GPL-3.0-or-later"

  on_macos do
    on_arm do
      url "https://git.kingepic84.page/kingepic84/imux/releases/download/v#{version}/imux-aarch64-apple-darwin.tar.gz"
      sha256 "550b62f14787ace0077b9a4fa267c227fc58b82b9ad2d63d9ed12de869b72ce6"
    end
    on_intel do
      url "https://git.kingepic84.page/kingepic84/imux/releases/download/v#{version}/imux-x86_64-apple-darwin.tar.gz"
      sha256 "7b6b887d9be6149ab42d3d65c80993337ca2d749784f2f340de81add38b6870f"
    end
  end

  on_linux do
    on_arm do
      url "https://git.kingepic84.page/kingepic84/imux/releases/download/v#{version}/imux-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "0368dbb11660ddf8b1b843552515a4afb20535a283e90554da2fbf3cecf29508"
    end
    on_intel do
      url "https://git.kingepic84.page/kingepic84/imux/releases/download/v#{version}/imux-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "4893fedaf9a48c4eaf2083ee0112ab7581a273f59bcd3653f2689f4c4ffec904"
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
