#
# Copyright (c) 2017 Yu Wang <wangyucn@gmail.com>
#
# This is free software, licensed under the MIT.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=speederv2-tunnel
PKG_VERSION:=20230206.0
PKG_RELEASE:=1

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://github.com/wangyu-/UDPspeeder.git
PKG_SOURCE_VERSION:=17694ecaa9681b04498709ba7526c8a8f022b512
PKG_MIRROR_HASH:=ee1ec48c5d857602069908e474959ccd76e66e9f2e484e32ce311a5e4afe477f

PKG_SOURCE_SUBDIR:=$(PKG_NAME)-$(PKG_VERSION)
PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.xz

PKG_LICENSE:=MIT
PKG_LICENSE_FILES:=LICENSE
PKG_MAINTAINER:=wangyu-

PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)-$(PKG_VERSION)

PKG_BUILD_PARALLEL:=1

include $(INCLUDE_DIR)/package.mk

define Package/speederv2-tunnel
	SECTION:=net
	CATEGORY:=Network
	TITLE:=UDP Network Speed-Up Tool
	URL:=https://github.com/wangyu-/UDPspeeder
	DEPENDS:= +libstdcpp +librt
endef

define Package/speederv2-tunnel/description
	 A Tunnel which Improves your Network Quality on a High-latency Lossy Link by using Forward Error Correction,for All Traffics(TCP/UDP/ICMP)
endef

MAKE_FLAGS += cross

define Build/Prepare
	$(PKG_UNPACK)
	sed -i 's/cc_cross=.*/cc_cross=$(TARGET_CXX)/g' $(PKG_BUILD_DIR)/makefile
	sed -i '/\gitversion/d' $(PKG_BUILD_DIR)/makefile
	echo 'const char * const gitversion = "$(PKG_VERSION)";' > $(PKG_BUILD_DIR)/git_version.h
	$(Build/Patch)
endef

define Package/speederv2-tunnel/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/speederv2_cross $(1)/usr/bin/speederv2
	( cd $(1)/usr/bin; $(LN) speederv2 udpspeeder; )
endef

$(eval $(call BuildPackage,speederv2-tunnel))
