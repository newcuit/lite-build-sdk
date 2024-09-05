export CC ?= cc
export TOPDIR=$(shell pwd)

include $(TOPDIR)/include/rules.mk
include $(TOPDIR)/include/toplevel.mk

all: prepare mconf .config
	$(QUIET)$(SUBMAKE) package || exit

prepare:
	$(QUIET)TOPDIR=$(TOPDIR) $(SCRIPTS_DIR)/download_env.sh

conf_prepare: prepare
	$(QUIET)TOPDIR=$(TOPDIR) $(SCRIPTS_DIR)/init_config.sh

.config:
	@echo >&2 '***'
	@echo >&2 '*** Configuration file "$@" not found!'
	@echo >&2 '***'
	@echo >&2 '*** Please run "make menuconfig".'
	@echo >&2 '***'
	@/bin/false

mconf:
	$(QUIET)$(SUBMAKE) $(MCONF_DIR)

menuconfig: conf_prepare mconf
	$(QUIET)$(MCONF_DIR)/mconf Config.in

clean:
	rm -rf $(TMP_DIR) $(BUILD_DIR)

distclean: clean
	rm -rf $(DL_DIR)
	$(QUIET)$(SUBMAKE) $(MCONF_DIR) clean

.PHONY: menuconfig clean prepare config_prepare
