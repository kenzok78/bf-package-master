# SPDX-License-Identifier: GPL-3.0-only
#
# Copyright (C) 2021 ImmortalWrt.org

include $(TOPDIR)/rules.mk

PKG_NAME:=v2ray-core-v5
PKG_VERSION:=5.37.0
PKG_RELEASE:=1

PKG_SOURCE_PROTO:=git
PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=https://github.com/v2fly/v2ray-core.git
PKG_SOURCE_DATE:=2025-07-07
PKG_SOURCE_VERSION:=143b1c86ff3388289a116c57ec60ad220771c4d6
PKG_MIRROR_HASH:=ef92f4515edd633ecbfac5b3e880e9b9673446278b4cf28a1fe70d3222e3bc36

# PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
# PKG_SOURCE_URL:=https://codeload.github.com/v2fly/v2ray-core/tar.gz/v$(PKG_VERSION)?
# PKG_HASH:=d9973bafd3020f60a51fa3495b24ab417b08b3c8f9539a3748d00da6c68d0103

PKG_LICENSE:=MIT
PKG_LICENSE_FILES:=LICENSE
PKG_MAINTAINER:=Tianling Shen <cnsztl@immortalwrt.org>
PKG_CPE_ID:=cpe:/a:v2fly:v2ray-core

PKG_CONFIG_DEPENDS:= \
	CONFIG_V2RAY_CORE-V5_COMPRESS_GOPROXY \
	CONFIG_V2RAY_CORE-V5_COMPRESS_UPX

PKG_BUILD_DEPENDS:=golang/host
PKG_BUILD_PARALLEL:=1
PKG_USE_MIPS16:=0
PKG_BUILD_FLAGS:=no-mips16

GO_PKG:=github.com/v2fly/v2ray-core/v5
GO_PKG_BUILD_PKG:=$(GO_PKG)/main
GO_PKG_LDFLAGS:=-s -w
GO_PKG_LDFLAGS_X:= \
	$(GO_PKG).build=OpenWrt \
	$(GO_PKG).version=$(PKG_VERSION)

include $(INCLUDE_DIR)/package.mk
include $(TOPDIR)/feeds/packages/lang/golang/golang-package.mk

define Package/v2ray-v5/template
  TITLE:=A proxy platform to bypass network restrictions
  SECTION:=net
  CATEGORY:=Network
  URL:=https://www.v2fly.org
endef

define Package/v2ray-core-v5
  $(call Package/v2ray-v5/template)
  DEPENDS:=$(GO_ARCH_DEPENDS) +ca-bundle
endef

define Package/v2ray-v5-example
  $(call Package/v2ray-v5/template)
  TITLE+= (example configs)
  DEPENDS:=v2ray-core-v5
  PKGARCH:=all
endef

define Package/v2ray-v5-extra
  $(call Package/v2ray-v5/template)
  TITLE+= (extra resources)
  DEPENDS:=v2ray-core-v5
  PKGARCH:=all
endef

define Package/v2ray-v5/description
  Project V is a set of network tools that help you to build your own computer network.
  It secures your network connections and thus protects your privacy.
endef

define Package/v2ray-core-v5/description
  $(call Package/v2ray-v5/description)
endef

define Package/v2ray-v5-example/description
  $(call Package/v2ray-v5/description)

  This includes example configuration files for v2ray-core-v5.
endef

define Package/v2ray-v5-extra/description
  $(call Package/v2ray-v5/description)

  This includes extra resources for v2ray-core-v5.
endef

define Package/v2ray-core-v5/config
menu "v2ray-core-v5 Configuration"
	depends on PACKAGE_v2ray-core-v5

config V2RAY_CORE-V5_COMPRESS_GOPROXY
	bool "Compiling with GOPROXY proxy"
	default n

config V2RAY_CORE-V5_COMPRESS_UPX
	bool "Compress executable files with UPX"
	depends on !mips64
	default n
endmenu
endef

define Package/v2ray-core-v5/conffiles
/etc/config/v2ray
/etc/v2ray/
endef

ifneq ($(CONFIG_V2RAY_CORE-V5_COMPRESS_GOPROXY),)
	export GO111MODULE=on
	export GOPROXY=https://goproxy.baidu.com
endif

define Build/Compile
	$(call GoPackage/Build/Compile)
ifneq ($(CONFIG_V2RAY_CORE-V5_COMPRESS_UPX),)
	$(STAGING_DIR_HOST)/bin/upx --lzma --best $(GO_PKG_BUILD_BIN_DIR)/main
endif
endef

define Package/v2ray-core-v5/install
	$(call GoPackage/Package/Install/Bin,$(PKG_INSTALL_DIR))
	$(INSTALL_DIR) $(1)/usr/bin/
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/bin/main $(1)/usr/bin/v2ray

	$(INSTALL_DIR) $(1)/etc/v2ray/
	$(INSTALL_DATA) $(PKG_BUILD_DIR)/release/config/config.json $(1)/etc/v2ray/

	$(INSTALL_DIR) $(1)/etc/config/
	$(INSTALL_CONF) $(CURDIR)/files/v2ray.conf $(1)/etc/config/v2ray
	$(INSTALL_DIR) $(1)/etc/init.d/
	$(INSTALL_BIN) $(CURDIR)/files/v2ray.init $(1)/etc/init.d/v2ray
endef

define Package/v2ray-v5-example/install
	$(INSTALL_DIR) $(1)/etc/v2ray/
	$(INSTALL_DATA) $(PKG_BUILD_DIR)/release/config/vpoint_socks_vmess.json $(1)/etc/v2ray/
	$(INSTALL_DATA) $(PKG_BUILD_DIR)/release/config/vpoint_vmess_freedom.json $(1)/etc/v2ray/
endef

define Package/v2ray-v5-extra/install
	$(INSTALL_DIR) $(1)/usr/share/v2ray/
	$(CP) $(PKG_BUILD_DIR)/release/extra/* $(1)/usr/share/v2ray/
endef

$(eval $(call BuildPackage,v2ray-core-v5))
$(eval $(call BuildPackage,v2ray-v5-example))
$(eval $(call BuildPackage,v2ray-v5-extra))
