# SPDX-License-Identifier: GPL-3.0-only
#
# Copyright (C) 2022 ImmortalWrt.org

include $(TOPDIR)/rules.mk

LUCI_TITLE:=LuCI for Zerotier
LUCI_DEPENDS:=+luci-base +zerotier +jsonfilter +ucode
LUCI_PKGARCH:=all

define Package/luci-app-zerotier-update2/conffiles
/etc/config/zero/
/etc/config/zerotier
endef

include $(TOPDIR)/feeds/luci/luci.mk

# call BuildPackage - OpenWrt buildroot signature
