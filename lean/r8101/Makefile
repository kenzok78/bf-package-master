# SPDX-License-Identifier: GPL-2.0-only
#
# Copyright (C) 2022 ImmortalWrt.org

include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/kernel.mk

PKG_NAME:=r8101
PKG_VERSION:=1.038.02
PKG_RELEASE:=3

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://github.com/sbwml/package_kernel_r8101
PKG_SOURCE_VERSION:=5dea36329c0524490c093991801973fc48d92a8b
PKG_MIRROR_HASH:=f4182719b25cd177023dddd6f0f555597c8e340fa38127566681d10be885dd9a
PKG_BUILD_DIR:=$(KERNEL_BUILD_DIR)/$(PKG_NAME)-$(PKG_VERSION)

PKG_MAINTAINER:=Tianling Shen <cnsztl@immortalwrt.org>
PKG_LICENSE:=GPL-2.0-only
PKG_BUILD_PARALLEL:=1

include $(INCLUDE_DIR)/package.mk

define KernelPackage/r8101
  TITLE:=Driver for Realtek r8101 chipsets
  SUBMENU:=Network Devices
  DEPENDS:=@PCI_SUPPORT
  FILES:= $(PKG_BUILD_DIR)/src/r8101.ko
  AUTOLOAD:=$(call AutoProbe,r8101)
endef

define Package/r8101/description
  This package contains a driver for Realtek r8101 chipsets.
endef

define Build/Compile
	+$(KERNEL_MAKE) M=$(PKG_BUILD_DIR)/src modules
endef

$(eval $(call KernelPackage,r8101))
