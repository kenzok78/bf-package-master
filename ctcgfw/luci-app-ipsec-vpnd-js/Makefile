include $(TOPDIR)/rules.mk

LUCI_TITLE:=LuCI support for IPSec VPN Server (IKEv1 with PSK and Xauth)
LUCI_DEPENDS:=+strongswan +kmod-tun \
  +PACKAGE_strongswan:strongswan-mod-kernel-libipsec \
  +PACKAGE_strongswan:strongswan-mod-xauth-generic \
  +(PACKAGE_strongswan-mod-kdf||PACKAGE_strongswan-mod-openssl||PACKAGE_strongswan-mod-wolfssl):strongswan-minimal
LUCI_PKGARCH:=all

define Package/luci-app-ipsec-vpnd-js/conffiles
/etc/config/ipsec-vpnd
endef

include $(TOPDIR)/feeds/luci/luci.mk

# call BuildPackage - OpenWrt buildroot signature
