# SPDX-License-Identifier: GPL-3.0-only
#
# Copyright (C) 2021 ImmortalWrt.org

include $(TOPDIR)/rules.mk

PKG_NAME:=mosdns
PKG_VERSION:=5.3.3
PKG_RELEASE:=1

# PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
# PKG_SOURCE_URL:=https://codeload.github.com/IrineSistiana/mosdns/tar.gz/v$(PKG_VERSION)?
# PKG_HASH:=b6c1c8a46263a64824932293c0bed0a79d34587ff16806b5350e94e72268cf97

PKG_SOURCE_PROTO:=git
PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=https://github.com/IrineSistiana/mosdns.git
PKG_SOURCE_VERSION:=525c39406d2e4aa798b8ab113365abc3be643742
PKG_MIRROR_HASH:=3bff973616829838d5aaac5e495fd0c1ed8a08ebef13d5dc6c9e2947a8f49f5f

PKG_LICENSE:=GPL-3.0
PKG_LICENSE_FILES:=LICENSE
PKG_MAINTAINER:=Tianling Shen <cnsztl@immortalwrt.org>

PKG_CONFIG_DEPENDS:= \
	CONFIG_MOSDNS_COMPRESS_GOPROXY \
	CONFIG_MOSDNS_COMPRESS_UPX

PKG_BUILD_DEPENDS:=golang/host
PKG_BUILD_PARALLEL:=1
# PKG_USE_MIPS16:=0
PKG_BUILD_FLAGS:=no-mips16

GO_PKG:=github.com/IrineSistiana/mosdns
GO_PKG_LDFLAGS:=-s -w
GO_PKG_LDFLAGS_X:=main.version=v$(PKG_VERSION)

include $(INCLUDE_DIR)/package.mk
include $(TOPDIR)/feeds/packages/lang/golang/golang-package.mk

define Package/mosdns/Default
  SECTION:=net
  CATEGORY:=Network
  SUBMENU:=IP Addresses and Names
  TITLE:=A plug-in DNS forwarder/splitter
  URL:=https://github.com/IrineSistiana/mosdns
  DEPENDS:=$(GO_ARCH_DEPENDS) +ca-bundle
endef

define Package/mosdns
  $(call Package/mosdns/Default)
endef

define Package/mosdns-v5
  $(call Package/mosdns/Default)
endef

define Package/mosdns-ssrp
  $(call Package/mosdns/Default)
endef

define Package/mosdns/config
config MOSDNS_COMPRESS_GOPROXY
	bool "Compiling with GOPROXY proxy"
	default n

config MOSDNS_COMPRESS_UPX
	bool "Compress executable files with UPX"
	depends on !mips64
	default n
endef

ifeq ($(CONFIG_MOSDNS_COMPRESS_GOPROXY),y)
	export GO111MODULE=on
	export GOPROXY=https://goproxy.baidu.com
endif

define Build/Prepare
	$(call Build/Prepare/Default)
endef

# Package/mosdns-v5/config=$(Package/mosdns/config)
# Package/mosdns-ssrp/config=$(Package/mosdns/config)
# GO_PKG_TARGET_VARS:=$(filter-out CGO_ENABLED=%,$(GO_PKG_TARGET_VARS)) CGO_ENABLED=0

define Package/mosdns/conffiles
/etc/mosdns/
endef

define Build/Compile
	$(call GoPackage/Build/Compile)
ifneq ($(CONFIG_MOSDNS_COMPRESS_UPX),)
	$(STAGING_DIR_HOST)/bin/upx --lzma --best $(GO_PKG_BUILD_BIN_DIR)/mosdns
endif
endef

define Package/mosdns/install
	$(call GoPackage/Package/Install/Bin,$(1))

	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/scripts/openwrt/mosdns-init-openwrt $(1)/etc/init.d/mosdns

	$(INSTALL_DIR) $(1)/etc/mosdns
	$(INSTALL_DATA) ./files/config.yaml $(1)/etc/mosdns/config.yaml
endef

define Package/mosdns-v5/install
	$(call GoPackage/Package/Install/Bin,$(1))
endef

define Package/mosdns-ssrp/install
	$(call GoPackage/Package/Install/Bin,$(1))

	$(INSTALL_DIR) $(1)/etc/mosdns
	$(INSTALL_DATA) ./ssrp-files/config.yaml.tpl $(1)/etc/mosdns/config.yaml.tpl
endef

define Package/mosdns/postinst
#!/bin/sh

# check if we are on real system
if [ -z "$${IPKG_INSTROOT}" ]; then
	/etc/init.d/mosdns stop >/dev/null 2>&1
	/etc/init.d/mosdns disable >/dev/null 2>&1
fi
exit 0
endef

$(eval $(call GoBinPackage,mosdns))
$(eval $(call BuildPackage,mosdns))
$(eval $(call BuildPackage,mosdns-v5))
$(eval $(call BuildPackage,mosdns-ssrp))
