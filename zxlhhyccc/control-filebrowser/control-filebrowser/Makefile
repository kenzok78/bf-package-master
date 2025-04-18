#
# Copyright (C) 2021 ImmortalWrt
# This is free software, licensed under the GNU General Public License v3.
# See /LICENSE.txt for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=control-filebrowser
PKG_VERSION:=2.23.0
PKG_RELEASE:=$(AUTORELEASE)

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://github.com/filebrowser/filebrowser
PKG_SOURCE_VERSION:=02db83c72ef3e14bac8df085a49f873261c6fb69
PKG_MIRROR_HASH:=d41d86a37189c1d5a8982af42ef984f0ddda133fc48b1d5d6b817ee68dc14abf

PKG_LICENSE:=Apache-2.0
PKG_LICENSE_FILES:=LICENSE
PKG_MAINTAINER:=CN_SZTL <cnsztl@immortalwrt.org>

PKG_BUILD_DEPENDS:=golang/host node/host
PKG_BUILD_PARALLEL:=1
# PKG_USE_MIPS16:=0
PKG_BUILD_FLAGS:=no-mips16

PKG_CONFIG_DEPENDS:= \
	CONFIG_FILEBROWSER_COMPRESS_GOPROXY \
	CONFIG_FILEBROWSER_COMPRESS_UPX

GO_PKG:=github.com/filebrowser/filebrowser
GO_PKG_LDFLAGS:=-s -w
GO_PKG_LDFLAGS_X:= \
	$(GO_PKG)/v2/version.CommitSHA=$(PKG_SOURCE_VERSION) \
	$(GO_PKG)/v2/version.Version=$(PKG_VERSION)

include $(INCLUDE_DIR)/package.mk
include $(TOPDIR)/feeds/packages/lang/golang/golang-package.mk

define Package/control-filebrowser
  SECTION:=utils
  CATEGORY:=Utilities
  TITLE:=Web File Browser
  URL:=https://github.com/filebrowser/filebrowser
  DEPENDS:=$(GO_ARCH_DEPENDS)
endef

define Package/control-filebrowser/description
  filebrowser provides a file managing interface within a specified directory
  and it can be used to upload, delete, preview, rename and edit your files.
  It allows the creation of multiple users and each user can have its own directory.
  It can be used as a standalone app or as a middleware.
endef

define Package/control-filebrowser/config
config FILEBROWSER_COMPRESS_GOPROXY
	bool "Compiling with GOPROXY proxy"
	default n

config FILEBROWSER_COMPRESS_UPX
	bool "Compress executable files with UPX"
	depends on !mips64
	default n
endef

ifeq ($(CONFIG_FILEBROWSER_COMPRESS_GOPROXY),y)
export GO111MODULE=on
export GOPROXY=https://goproxy.io
endif

define Build/Compile
	( \
		pushd "$(PKG_BUILD_DIR)/frontend" ; \
		npm ci; \
		npm run lint ; \
		npm run build ; \
		popd ; \
		$(call GoPackage/Build/Compile) ; \
	)
ifeq ($(CONFIG_FILEBROWSER_COMPRESS_UPX),y)
	$(STAGING_DIR_HOST)/bin/upx --lzma --best $(GO_PKG_BUILD_BIN_DIR)/filebrowser
endif
endef

define Package/control-filebrowser/install
	$(call GoPackage/Package/Install/Bin,$(1))
endef

$(eval $(call GoBinPackage,control-filebrowser))
$(eval $(call BuildPackage,control-filebrowser))
