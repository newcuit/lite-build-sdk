include $(TOPDIR)/include/toplevel.mk
include $(TOPDIR)/.config

BUILD_SRC_DIR := $(DL_DIR)/$(PKG_NAME)
STAMP_DOWNLOAD := $(BUILD_SRC_DIR)/.download
BUILD_PACKAGE_DIR := $(PACKAGE_DIR)/$(PKG_NAME)

define Build/Prepare/Default
$(call BuildPrepare,$(1))
endef

define Build/Compile/Default
endef

define Build/Install/Default
$(call InstallPrepare,$(1))
endef

define Build/Depends/Default
	$(QUIET)$(SCRIPTS_DIR)/build_depends.sh $(1)
endef

define Build/Patch
	$(QUIET)[ -e patches -a -d patches ] && {                         \
		$(CP) -r patches  $(BUILD_PACKAGE_DIR);                       \
		cd  $(BUILD_PACKAGE_DIR) && $(PTOOL) import patches/*.patch;  \
		cd  $(BUILD_PACKAGE_DIR) && $(PTOOL) push -a;                 \
	} || {                                                            \
		/bin/true;                                                    \
	}
endef

define Build/Unpack
	$(QUIET)if [ -n "$(FILE_NAME)" ]; then                              \
		tar -xvf $(BUILD_SRC_DIR)/$(FILE_NAME) -C $(BUILD_PACKAGE_DIR); \
	elif [ -n "$(URL)" ];then                                           \
		$(CP) -ra $(BUILD_SRC_DIR)/. $(BUILD_PACKAGE_DIR);              \
	else                                                                \
		/bin/true;                                                      \
	fi

	$(QUIET)[ -e src -a -d src ] && {                                   \
		$(CP) -r src/. $(BUILD_PACKAGE_DIR);                            \
	} || {                                                              \
		/bin/true;                                                      \
	}
endef

define Build/Download
	$(QUIET)mkdir -p $(BUILD_SRC_DIR)

	$(QUIET)[ ! -e $(STAMP_DOWNLOAD) -a -n "$(FILE_NAME)" -a -n "$(URL)" ] && {    \
		wget $(URL) -O $(BUILD_SRC_DIR)/$(FILE_NAME);                              \
		touch $(STAMP_DOWNLOAD);                                                   \
	} || {                                                                         \
		/bin/true;                                                                 \
	}

	$(QUIET)[ ! -e $(STAMP_DOWNLOAD) -a "$(URL)" != "" -a -z "$(FILE_NAME)" ] && { \
		[  -z "$(BRANCH)" ] && {                                                   \
			git clone $(URL) $(BUILD_SRC_DIR);                                     \
		} || {                                                                     \
			git clone $(URL) -b $(BRANCH) $(BUILD_SRC_DIR);                        \
		};                                                                         \
		cd $(BUILD_SRC_DIR) && git submodule update --init --recursive;            \
		touch $(STAMP_DOWNLOAD);                                                   \
	} || {                                                                         \
		/bin/true;                                                                 \
	}

$(call Build/Unpack)
$(call Build/Patch)
endef

define BuildPrepare
$(call Build/Depends/Default,$(PKG_CONFIG_IN))
	$(RM) -r $(BUILD_PACKAGE_DIR)
	$(INSTALL_DIR) $(BUILD_PACKAGE_DIR)
$(call Build/Download,)
endef

define InstallPrepare
	$(INSTALL_DIR) $(TARGET_DIR)
endef

PKG_CONFIG_IN := $(TOPDIR)/$(MODULE)/$(PKG_NAME)/Config.in
STAMP_BUILT := $(BUILD_PACKAGE_DIR)/.built

define BuildPackage
ifeq ($(PKG_CONFIG),)
$(strip $(1))/$(strip $(2))/built:
	$(QUIET)$(PASS)
$(strip $(1))/$(strip $(2))/prepare:
	$(QUIET)$(PASS)
$(strip $(1))/$(strip $(2))/compile:
	$(QUIET)$(PASS)
$(strip $(1))/$(strip $(2))/install:
	$(QUIET)$(PASS)
$(strip $(1))/$(strip $(2))/clean:
	$(QUIET)$(PASS)
else
$(STAMP_BUILT):
$(call BuildPrepare,$(2))
$(call InstallPrepare,$(2))
$(call Package/prepare,$$(strip $(2)))
$(call Package/compile,$(strip $(2)))
$(call Package/install,$(strip $(2)))
	$(QUIET)touch $$@

$(strip $(1))/$(strip $(2))/built: $(STAMP_BUILT)
	$(QUIET)$(PASS)

$(strip $(1))/$(strip $(2))/install: $(strip $(1))/$(strip $(2))/compile
$(call InstallPrepare,$(2))
$(call Package/install,$(strip $(2)))

$(strip $(1))/$(strip $(2))/prepare:
$(call BuildPrepare,$(2))
$(call Package/prepare,$$(strip $(2)))

$(strip $(1))/$(strip $(2))/compile:$(strip $(1))/$(strip $(2))/prepare
$(call Package/compile,$(strip $(2)))

$(strip $(1))/$(strip $(2))/dirty:
	$(QUIET)$(RM) -r $(STAMP_BUILT)

$(strip $(1))/$(strip $(2))/clean:
$(call Package/uninstall,$(strip $(2)))
	$(QUIET)$(RM) -r $(BUILD_PACKAGE_DIR)
endif

.PHONY: $(strip $(1))/$(strip $(2))/prepare
.PHONY: $(strip $(1))/$(strip $(2))/compile
.PHONY: $(strip $(1))/$(strip $(2))/install
.PHONY: $(strip $(1))/$(strip $(2))/clean
.PHONT: $(strip $(1))/$(strip $(2))/built
endef
