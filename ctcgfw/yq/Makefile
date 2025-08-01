include $(TOPDIR)/rules.mk

PKG_NAME:=yq
PKG_VERSION:=4.47.1
PKG_RELEASE:=1

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=https://codeload.github.com/mikefarah/yq/tar.gz/v$(PKG_VERSION)?
PKG_HASH:=48ef09b9ffdb80f26ee516fa2fc83f713c1b49f503cedef79a96435509d456af

# PKG_SOURCE_PROTO:=git
# PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
# PKG_SOURCE_URL:=https://github.com/mikefarah/yq.git
# PKG_SOURCE_VERSION:=bbe196ba11a42c26f3f2aba0063760a301d81756
# PKG_MIRROR_HASH:=994ecab727776e0ed1baf08079c15deda701c40eafdba18ae3703ee86fa45541

PKG_MAINTAINER:=Tianling Shen <cnsztl@immortalwrt.org>
PKG_LICENSE:=MIT
PKG_LICENSE_FILES:=LICENSE

PKG_BUILD_DEPENDS:=golang/host
PKG_BUILD_PARALLEL:=1
PKG_USE_MIPS16:=0
PKG_BUILD_FLAGS:=no-mips16

PKG_CONFIG_DEPENDS:= \
	CONFIG_YQ_COMPRESS_GOPROXY \
	CONFIG_YQ_COMPRESS_UPX

GO_PKG:=github.com/mikefarah/yq
GO_PKG_LDFLAGS:=-s -w

include $(INCLUDE_DIR)/package.mk
include $(TOPDIR)/feeds/packages/lang/golang/golang-package.mk

define Package/yq
  SECTION:=utils
  CATEGORY:=Utilities
  TITLE:=Portable command-line YAML processor
  URL:=https://mikefarah.gitbook.io/yq/
  DEPENDS:=$(GO_ARCH_DEPENDS)
endef

define Package/yq/description
  The aim of the project is to be the jq or sed of yaml files.
endef

define Package/yq/config
config YQ_COMPRESS_GOPROXY
	bool "Compiling with GOPROXY proxy"
	default n

config YQ_COMPRESS_UPX
	bool "Compress executable files with UPX"
	depends on !mips64
	default n
endef

ifeq ($(CONFIG_YQ_COMPRESS_GOPROXY),y)
export GO111MODULE=on
export GOPROXY=https://goproxy.baidu.com
endif

define Build/Compile
	$(call GoPackage/Build/Compile)
ifeq ($(CONFIG_YQ_COMPRESS_UPX),y)
	$(STAGING_DIR_HOST)/bin/upx --lzma --best $(GO_PKG_BUILD_BIN_DIR)/yq
endif
endef

$(eval $(call GoBinPackage,yq))
$(eval $(call BuildPackage,yq))
