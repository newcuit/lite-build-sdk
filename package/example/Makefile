include $(TOPDIR)/include/rules.mk

MODULE:=package
PKG_NAME:=example

include $(TOPDIR)/include/package.mk

PKG_CONFIG:=$(CONFIG_HELLO_EXAMPLE)
define Package/prepare
	@echo "Package $(1) prepare"
	$(CP) src/* $(BUILD_PACKAGE_DIR)
endef

define Package/compile
	echo "Package $(1) compile"
	$(MAKE) -C $(BUILD_PACKAGE_DIR)
	echo $(CC) $^ $(LDFLAGS)  $(CFLAGS) -o $@ -lexample
endef

define Package/install
	@echo "Package $(1) install"
	$(INSTALL_DIR) $(TARGET_DIR)/bin
	$(INSTALL_BIN) $(BUILD_PACKAGE_DIR)/example $(TARGET_DIR)/bin
endef

define Package/uninstall
	$(RM) $(TARGET_DIR)/bin/example
endef

$(eval $(call BuildPackage, $(MODULE), $(PKG_NAME)))
