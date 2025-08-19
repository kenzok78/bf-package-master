#!/bin/bash
# 自动更新 Xray-core 版本、commit 并计算 HASH

set -e

pushd ~/ax6-6.6 || exit 1

export CURDIR="$(cd "$(dirname $0)"; pwd)"

OLD_VER=$(grep -oP '^PKG_VERSION:=\K.*' "$CURDIR/Makefile")
OLD_COMMIT=$(grep -oP '^PKG_SOURCE_VERSION:=\K.*' "$CURDIR/Makefile")
OLD_CHECKSUM=$(grep -oP '^PKG_MIRROR_HASH:=\K.*' "$CURDIR/Makefile")

REPO="https://github.com/yisier/nps"
REPO_API="https://api.github.com/repos/yisier/nps/releases/latest"

# 获取新 TAG、DATA、COMMIT 等
TAG="$(curl -H "Authorization: $GITHUB_TOKEN" -sL "$REPO_API" | jq -r ".tag_name")"
USE_VER="${TAG#v}"  # TAG 形如 v1.8.11

COMMIT="$(git ls-remote "$REPO" HEAD | cut -f1)"

# 如果版本或 commit 变了，才清除并更新
if [ "$USE_VER" != "$OLD_VER" ] || \
    [ "$COMMIT" != "$OLD_COMMIT" ]; then
    echo "⬆️  新版本: $USE_VER / $COMMIT，旧版本: $OLD_VER / $OLD_COMMIT"

    # 删除旧源码包和哈希
    rm -f dl/nps-${OLD_VER}.tar.gz

    # 清理旧缓存（触发重新编译）
    make package/nps/clean V=s

    # 修改 Makefile 中的版本和提交哈希
    ./staging_dir/host/bin/sed -i "$CURDIR/Makefile" \
        -e "s|^PKG_VERSION:=.*|PKG_VERSION:=${USE_VER}|" \
        -e "s|^PKG_SOURCE_VERSION:=.*|PKG_SOURCE_VERSION:=${COMMIT}|" \
        -e "s|^PKG_MIRROR_HASH:=.*|PKG_MIRROR_HASH:=|"

    echo "🧹 清空旧 HASH：$OLD_CHECKSUM"

    # 重新下载源码包
    make package/nps/download V=s

    # 重新生成校验和
    TARFILE="dl/nps-${USE_VER}.tar.gz"
    if [ -f "$TARFILE" ]; then
        CHECKSUM=$(./staging_dir/host/bin/mkhash sha256 "$TARFILE")
        ./staging_dir/host/bin/sed -i "$CURDIR/Makefile" \
            -e "s|^PKG_MIRROR_HASH:=.*|PKG_MIRROR_HASH:=${CHECKSUM}|"
        echo "✅ 校验和已更新：$CHECKSUM"
    else
        echo "⚠️ 未找到源码包：$TARFILE"
        exit 1
    fi
else
    echo "✅ 无需更新，版本和 commit 均一致"
fi

popd
