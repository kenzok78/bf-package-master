# SPDX-License-Identifier: GPL-3.0-only
#
# Copyright (C) 2021 ImmortalWrt.org

include $(TOPDIR)/rules.mk

PKG_NAME:=trojan-go
PKG_VERSION:=0.10.6
PKG_RELEASE:=1

PKG_SOURCE_PROTO:=git
PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=https://github.com/p4gefau1t/trojan-go.git
PKG_SOURCE_VERSION:=2dc60f52e79ff8b910e78e444f1e80678e936450
PKG_MIRROR_HASH:=788db4cba85e007b080ed56ba14caf0b8ec14e311f1dc6aed408ee2adc989a1b

#PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
#PKG_SOURCE_URL:=https://codeload.github.com/p4gefau1t/trojan-go/tar.gz/v$(PKG_VERSION)?
#PKG_HASH:=925f02647dda944813f1eab0b71eac98b83eb5964ef5a6f63e89bc7eb4486c1f

PKG_LICENSE:=GPL-3.0-only
PKG_LICENSE_FILES:=LICENSE
PKG_MAINTAINER:=Tianling Shen <cnsztl@immortalwrt.org>

PKG_CONFIG_DEPENDS:= \
	CONFIG_TROJAN_GO_COMPRESS_GOPROXY \
	CONFIG_TROJAN_GO_COMPRESS_UPX

PKG_BUILD_DEPENDS:=golang/host
PKG_BUILD_PARALLEL:=1
PKG_USE_MIPS16:=0
PKG_BUILD_FLAGS:=no-mips16

GO_PKG:=github.com/p4gefau1t/trojan-go
GO_PKG_BUILD_PKG:=$(GO_PKG)
GO_PKG_LDFLAGS:=-s -w
GO_PKG_LDFLAGS_X:= \
	$(GO_PKG)/constant.Version=$(PKG_VERSION) \
	$(GO_PKG)/constant.Commit=v$(PKG_VERSION)
GO_PKG_TAGS:=full

include $(INCLUDE_DIR)/package.mk
include $(TOPDIR)/feeds/packages/lang/golang/golang-package.mk

define Package/trojan-go
  SECTION:=net
  CATEGORY:=Network
  SUBMENU:=Web Servers/Proxies
  TITLE:=A Trojan proxy written in Go
  DEPENDS:=$(GO_ARCH_DEPENDS) +ca-bundle
  URL:=https://p4gefau1t.github.io/trojan-go/
endef

define Package/trojan-go/description
  Trojan features multiple protocols over TLS to avoid both
  active/passive detections and ISP QoS limitations.
endef

define Package/trojan-go/config
config TROJAN_GO_COMPRESS_GOPROXY
	bool "Compiling with GOPROXY proxy"
	default n

config TROJAN_GO_COMPRESS_UPX
	bool "Compress executable files with UPX"
	depends on !mips64
	default n
endef

ifeq ($(CONFIG_TROJAN_GO_COMPRESS_GOPROXY),y)
	export GO111MODULE=on
	export GOPROXY=https://goproxy.baidu.com
endif

define Build/Prepare
	$(call Build/Prepare/Default)
endef

define Build/UpdateDependencies
	cd $(PKG_BUILD_DIR) && \
		go get -u && \
		go mod tidy
endef

define Build/Compile
	$(call Build/UpdateDependencies)
	$(call GoPackage/Build/Compile)
ifeq ($(CONFIG_TROJAN_GO_COMPRESS_UPX),y)
	$(STAGING_DIR_HOST)/bin/upx --lzma --best $(GO_PKG_BUILD_BIN_DIR)/trojan-go
endif
endef

$(eval $(call GoBinPackage,trojan-go))
$(eval $(call BuildPackage,trojan-go))
