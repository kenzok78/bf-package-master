#
# Copyright (C) 2019-2020 Xingwang Liao
# Copyright (C) 2020-2021 Mattraks
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=xray
PKG_VERSION:=1.2.4
PKG_RELEASE:=1
PKG_BUILD_DIR:=$(BUILD_DIR)/xray-$(PKG_VERSION)

PKG_SOURCE_PROTO:=git
PKG_SOURCE:=xray-core-$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=https://github.com/XTLS/Xray-core.git
PKG_MIRROR_HASH:=9a53be50ee3573ab7ae46011a9307dda590f2d3672efcf1a7f452464d9ba7e9f
PKG_SOURCE_VERSION:=523c416bb56b3e2ffe101e7c02a323cfa770bfda

PKG_LICENSE:=MPL
PKG_LICENSE_FILES:=LICENSE

PKG_CONFIG_DEPENDS:= \
	CONFIG_XRAY_EXCLUDE_ASSETS \
	CONFIG_XRAY_COMPRESS_GOPROXY \
	CONFIG_XRAY_COMPRESS_UPX \
	CONFIG_XRAY_COMPATIBILITY_MODE

PKG_BUILD_DEPENDS:=golang/host
PKG_BUILD_PARALLEL:=1
# PKG_USE_MIPS16:=0
PKG_BUILD_FLAGS:=no-mips16

GO_PKG:=github.com/xtls/xray-core
GO_PKG_LDFLAGS:=-s -w
GO_PKG_LDFLAGS_X:= \
	$(GO_PKG)/core.version=$(PKG_VERSION) \
	$(GO_PKG)/core.codename=OpenWrt

include $(INCLUDE_DIR)/package.mk
include $(TOPDIR)/feeds/packages/lang/golang/golang-package.mk

define Package/$(PKG_NAME)
  TITLE:=A platform for building proxies
  SECTION:=net
  CATEGORY:=Network
  SUBMENU:=Project X
  DEPENDS:=$(GO_ARCH_DEPENDS) +ca-certificates
#  PROVIDES:=v2ray
endef

define Package/$(PKG_NAME)/description
Project X originates from XTLS protocol, provides a set of network tools such as Xray-core and Xray-flutter.
It secures your network connections and thus protects your privacy.

  This package contains Xray, geoip.dat and geosite.dat.
endef

define Package/$(PKG_NAME)/config
menu "Xray Configuration"
	depends on PACKAGE_xray

config XRAY_COMPRESS_GOPROXY
	bool "Compiling with GOPROXY proxy"
	default n

config XRAY_EXCLUDE_ASSETS
	bool "Exclude geoip.dat & geosite.dat"
	default y

config XRAY_COMPRESS_UPX
	bool "Compress executable files with UPX"
	default y

config XRAY_COMPATIBILITY_MODE
	bool "V2ray Compatibility mode(v2ray soft connection Xray)"
	default n
endmenu
endef

ifeq ($(CONFIG_XRAY_COMPRESS_GOPROXY),y)
export GO111MODULE=on
export GOPROXY=https://goproxy.io
#export GOPROXY=https://mirrors.aliyun.com/goproxy/
endif

GEOIP_VER:=202101280019
GEOIP_FILE:=geoip-$(GEOIP_VER).dat

define Download/geoip.dat
  URL:=https://github.com/v2fly/geoip/releases/$(GEOIP_VER)/download
  URL_FILE:=geoip.dat
  FILE:=$(GEOIP_FILE)
  HASH:=69bb1f820f416e4591a7b76bfabf9fde9cce6550cddcc1a99b2ccafeb2a8ebd3
endef

GEOSITE_VER:=20210130061540
GEOSITE_FILE:=geosite-$(GEOSITE_VER).dat

define Download/geosite.dat
  URL:=https://github.com/v2fly/domain-list-community/releases/$(GEOSITE_VER)/download
  URL_FILE:=dlc.dat
  FILE:=$(GEOSITE_FILE)
  HASH:=bc9748c95b0545376356174b005fccfbc21d647df46293d5197853ee06a9c0a2
endef

define Build/Prepare
	$(call Build/Prepare/Default)
ifneq ($(CONFIG_XRAY_EXCLUDE_ASSETS),y)
	# move file to make sure download new file every build
	mv -f $(DL_DIR)/$(GEOIP_FILE) $(PKG_BUILD_DIR)/geoip.dat
	mv -f $(DL_DIR)/$(GEOSITE_FILE) $(PKG_BUILD_DIR)/geosite.dat
endif
endef

define Build/Compile
	$(eval GO_PKG_BUILD_PKG:=$(GO_PKG)/main)
	$(call GoPackage/Build/Compile)
	mv -f $(GO_PKG_BUILD_BIN_DIR)/main $(GO_PKG_BUILD_BIN_DIR)/xray
ifeq ($(CONFIG_XRAY_COMPRESS_UPX),y)
	$(STAGING_DIR_HOST)/bin/upx --lzma --best $(GO_PKG_BUILD_BIN_DIR)/xray || true
endif
endef

define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(GO_PKG_BUILD_BIN_DIR)/xray $(1)/usr/bin
ifeq ($(CONFIG_XRAY_COMPATIBILITY_MODE),y)
	$(LN) xray $(1)/usr/bin/v2ray
endif
ifneq ($(CONFIG_XRAY_EXCLUDE_ASSETS),y)
	$(INSTALL_DIR) $(1)/usr/share/xray
	$(INSTALL_DATA) $(PKG_BUILD_DIR)/{geoip,geosite}.dat $(1)/usr/share/xray
endif
endef

ifneq ($(CONFIG_XRAY_EXCLUDE_ASSETS),y)
$(eval $(call Download,geoip.dat))
$(eval $(call Download,geosite.dat))
endif

$(eval $(call GoBinPackage,$(PKG_NAME)))
$(eval $(call BuildPackage,$(PKG_NAME)))
