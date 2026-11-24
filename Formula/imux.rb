class Imux < Formula
  desc "Terminal multiplexer with images in the scrollback"
  homepage "https://imux.cc"
  version "0.1.1"
  license "GPL-3.0-or-later"

  on_macos do
    on_arm do
      url "https://git.kingepic84.page/kingepic84/imux/releases/download/v#{version}/imux-aarch64-apple-darwin.tar.gz"
      sha256 "4d8b3078c944553d43254294473e2847bf0baa180ace1376b1f93a5687cc3709"
    end
    on_intel do
      url "https://git.kingepic84.page/kingepic84/imux/releases/download/v#{version}/imux-x86_64-apple-darwin.tar.gz"
      sha256 "0526aabe771377813844a2348f211a95417af48bbb72fbe7c0e778621d1cbcd1"
    end
  end

  on_linux do
    on_arm do
      url "https://git.kingepic84.page/kingepic84/imux/releases/download/v#{version}/imux-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "6d5ba61d1a70b595916ae2cfdcca0f64f31395d8692d348b6fa8d30d3ab7e7e9"
    end
    on_intel do
      url "https://git.kingepic84.page/kingepic84/imux/releases/download/v#{version}/imux-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "4ab43cfa798e81739d20a3c7a9c91f4d962e9d38dac44a60cea9e3bee6991e1a"
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
