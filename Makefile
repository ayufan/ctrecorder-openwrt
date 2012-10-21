#
# Copyright (C) 2009-2011 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=ctrecorder
PKG_VERSION:=0.1.4
PKG_RELEASE:=1

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:= \
	http://software.klolik.org/files/
PKG_MD5SUM:=25b899faabc0e93dbbea907c83054866

PKG_FIXUP:=libtool

PKG_INSTALL:=1

include $(INCLUDE_DIR)/package.mk

define Package/ctrecorder
  SECTION:=net
  CATEGORY:=Network
  DEPENDS:=+libnfnetlink +libnetfilter-conntrack +kmod-nf-conntrack-netlink +zlib
  TITLE:=ctrecorder is event logger for Linux netfilter conntrack, part of software.klolik.org
  URL:=http://software.klolik.org/
endef

define Package/ctrecorder/conffiles
/etc/config/ctrecorder
endef

define Package/ctrecorder/description
  ctrecorder uses nf_conntrack_netlink module to receive netfilter events, that is adding and destroying conntrack entries.
  This allows saving start and end time of connection for specific protocol. Currently TCP and UDP are supported.
  Main application of ctrecorder is connections logging for security and anti-abuse reasons.
  Logs are especially useful for NAT-ed connection, as they contain both pre-NAT and post-NAT IPs and ports.
  Be aware, that using NOTRACK in raw table will hide packets from conntrack and effectively from ctrecorder too.
endef

TARGET_CFLAGS += $(FPIC)

CONFIGURE_ARGS += 

define Package/ctrecorder/install
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/src/ctrecorder $(1)/usr/sbin
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) ./files/ctrecorder.init $(1)/etc/init.d/ctrecorder
	$(INSTALL_DIR) $(1)/etc/config
	$(INSTALL_DATA) ./files/ctrecorder.config $(1)/etc/config/ctrecorder
endef

$(eval $(call BuildPackage,ctrecorder))
