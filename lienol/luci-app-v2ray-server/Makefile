# Copyright (C) 2018-2020 Lienol <lawlienol@gmail.com>
#
# This is free software, licensed under the GNU General Public License v3.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=luci-app-v2ray-server
LUCI_TITLE:=LuCI support for V2ray Server
LUCI_DEPENDS:=+unzip +v2ray-core-v5 +wget-ssl
LUCI_PKGARCH:=all
PKG_VERSION:=13

include $(TOPDIR)/feeds/luci/luci.mk

# call BuildPackage - OpenWrt buildroot signature
