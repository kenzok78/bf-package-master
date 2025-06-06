#
# Drivers Copyright (C) 2022 Intel Corporation
#
# This is free software, licensed under the GNU General Public License v2.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=kmod-igb-intel
PKG_VERSION:=5.19.2
PKG_RELEASE:=1

PKG_SOURCE_VERSION:=612a03b6d6a616d3e11f6a1dfda673e65ec68405
PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION)-$(PKG_SOURCE_VERSION).tar.gz
PKG_SOURCE_URL:=https://codeload.github.com/intel/ethernet-linux-igb/tar.gz/$(PKG_SOURCE_VERSION)?
PKG_HASH:=67366162306af3741dc2a6e9f0a58d05ee49057eb19c5946fb88ff065fe87c56

include $(INCLUDE_DIR)/kernel.mk
include $(INCLUDE_DIR)/package.mk

PKG_UNPACK:=zcat $(DL_DIR)/$(PKG_SOURCE) | $(TAR) -C $(PKG_BUILD_DIR) --strip-components=1 -xf -

define KernelPackage/igb-intel
  SUBMENU:=Network Devices
  TITLE:=Intel igb drivers - oot version from Intel
  DEPENDS:=@PCI_SUPPORT +kmod-i2c-core +kmod-i2c-algo-bit +kmod-ptp +kmod-hwmon-core
  CONFLICTS:=kmod-igb
  KCONFIG:=CONFIG_IGB \
    CONFIG_IGB_HWMON=y \
    CONFIG_IGB_DCA=n
  FILES:=$(PKG_BUILD_DIR)/src/igb.ko
  AUTOLOAD:=$(call AutoLoad,35,igb,1)
endef

define Build/Compile
	cd ${PKG_BUILD_DIR}/src; KSRC="$(LINUX_DIR)" \
		CONFFILE="$(LINUX_DIR)/.config" \
		OUT="$(PKG_BUILD_DIR)/src/kcompat_generated_defs.h" \
		bash kcompat-generator.sh
	+$(KERNEL_MAKE) M=$(PKG_BUILD_DIR)/src modules
endef

define KernelPackage/igb-intel/description
 Kernel modules for Intel igb out of tree drivers
endef

$(eval $(call KernelPackage,igb-intel))
