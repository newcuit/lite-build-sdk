include $(TOPDIR)/include/rules.mk

MODULE:=package
PKG_NAME:=example-lib

include $(TOPDIR)/include/package.mk

PKG_CONFIG:=$(CONFIG_LIB_EXAMPLE)
define Package/prepare
	@echo "Package $(1) prepare"
	$(CP) src/* $(BUILD_PACKAGE_DIR)
endef

define Package/compile
	echo "Package $(1) compile"
	$(MAKE) -C $(BUILD_PACKAGE_DIR)
endef

define Package/install
	@echo "Package $(1) install"
	$(INSTALL_DIR) $(TARGET_DIR)/lib
	$(INSTALL_DIR) $(TARGET_DIR)/include

	$(INSTALL_BIN) $(BUILD_PACKAGE_DIR)/libexample.so $(TARGET_DIR)/lib
	$(INSTALL_BIN) $(BUILD_PACKAGE_DIR)/example-lib.h $(TARGET_DIR)/include
endef

define Package/uninstall
	$(RM) $(TARGET_DIR)/lib/libexample.so
	$(RM) $(TARGET_DIR)/include/example-lib.h
endef

$(eval $(call BuildPackage, $(MODULE), $(PKG_NAME)))
