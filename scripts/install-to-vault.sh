#!/usr/bin/env bash
# 저장소의 배포 파일 셋을 볼트 플러그인 폴더에 반영한다.
#
# **방향은 언제나 저장소 → 볼트 하나뿐이다.** 볼트 쪽을 직접 고치면 사본이 갈라지고, 그때
# 어느 쪽이 원본인지 알 방법이 없어진다. 볼트에서 급히 고쳤다면 그 파일을 저장소로 되돌린 뒤
# 다시 이 스크립트를 돌린다(그 되돌림은 사람이 확인해야 하므로 스크립트로 만들지 않았다).
set -euo pipefail

VAULT="${OBSIDIAN_VAULT:-$HOME/Obsidian}"
DEST="$VAULT/.obsidian/plugins/single-html-export"
SRC="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

if [ ! -d "$VAULT/.obsidian" ]; then
  echo "볼트를 찾지 못했습니다: $VAULT (OBSIDIAN_VAULT 로 지정하세요)" >&2
  exit 1
fi

node --check "$SRC/main.js"

mkdir -p "$DEST"
for f in main.js manifest.json styles.css; do
  cp "$SRC/$f" "$DEST/$f"
done

echo "반영 완료 → $DEST"
echo "옵시디언에서 플러그인을 껐다 켜야 새 판이 로드됩니다."
