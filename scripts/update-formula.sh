#!/bin/bash
# Regenerates Formula/imux.rb from the latest imux release on Forgejo: the version and the four
# SHA-256 checksums come from the release itself. Does nothing when the formula is current.
#
#   scripts/update-formula.sh        prints "updated to X", or "up to date", or "no release yet"
set -eu
cd "$(dirname "$0")/.."

server="${IMUX_SERVER:-https://git.kingepic84.page}"
repo="kingepic84/imux"

resp="$(curl -fsS "$server/api/v1/repos/$repo/releases/latest" 2>/dev/null || true)"
tag="$(printf '%s' "$resp" | python3 -c 'import json,sys
try:
    print(json.load(sys.stdin)["tag_name"])
except Exception:
    pass')"
if [ -z "$tag" ]; then echo "no release yet"; exit 0; fi

ver="${tag#v}"
current=""
[ -f Formula/imux.rb ] && current="$(sed -n 's/^  version "\(.*\)"$/\1/p' Formula/imux.rb | head -1)"
if [ "$ver" = "$current" ]; then echo "up to date ($ver)"; exit 0; fi

base="$server/$repo/releases/download/$tag"
sum() { curl -fsSL "$base/imux-$1.tar.gz.sha256" | cut -d ' ' -f 1; }
mac_arm="$(sum aarch64-apple-darwin)"
mac_x86="$(sum x86_64-apple-darwin)"
lin_arm="$(sum aarch64-unknown-linux-gnu)"
lin_x86="$(sum x86_64-unknown-linux-gnu)"
for s in "$mac_arm" "$mac_x86" "$lin_arm" "$lin_x86"; do
  case "$s" in
    [0-9a-f]*) [ "${#s}" -eq 64 ] || { echo "bad checksum: $s" >&2; exit 1; } ;;
    *) echo "bad checksum: $s" >&2; exit 1 ;;
  esac
done

mkdir -p Formula
cat > Formula/imux.rb <<RUBY
class Imux < Formula
  desc "Terminal multiplexer with images in the scrollback"
  homepage "https://imux.cc"
  version "$ver"
  license "GPL-3.0-or-later"

  on_macos do
    on_arm do
      url "$server/$repo/releases/download/v#{version}/imux-aarch64-apple-darwin.tar.gz"
      sha256 "$mac_arm"
    end
    on_intel do
      url "$server/$repo/releases/download/v#{version}/imux-x86_64-apple-darwin.tar.gz"
      sha256 "$mac_x86"
    end
  end

  on_linux do
    on_arm do
      url "$server/$repo/releases/download/v#{version}/imux-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "$lin_arm"
    end
    on_intel do
      url "$server/$repo/releases/download/v#{version}/imux-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "$lin_x86"
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
RUBY
echo "updated to $ver"
