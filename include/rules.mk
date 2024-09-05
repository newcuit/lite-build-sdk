include $(TOPDIR)/include/toplevel.mk

CONFIGURE_CMD = ./configure
export LDFLAGS ?= -L$(TARGET_DIR)/lib
export CFLAGS ?= -O2 -I$(TARGET_DIR)/include
export CXXFLAGS ?= -O2 -I$(TARGET_DIR)/include
MAKE_FLAGS ?=

export CMAKE_LIBRARY_PATH ?="$(TARGET_DIR)/lib"
export CMAKE_INCLUDE_PATH ?="$(TARGET_DIR)/include"
CMAKE_FLAGS ?= -DBUILD_TESTING=0

%::
	$(QUIET)$(SUBMAKE) $(TOPDIR)/$(dir $@) $@
	$(QUIET)[ $$? -ne 0 ] && /bin/false || /bin/true;

ifneq ($(MODULE),)
MODULE_DIR := $(TOPDIR)/$(MODULE)
SUBDIRS := $(shell find . -name Config.in | xargs dirname {} | sed -nr 's/\.\///p')

define ModuleBuild
all:
	$(QUIET)for d in $(SUBDIRS);do                                  \
		cd $(TOPDIR);                                               \
		if [ -e $(MODULE_DIR)/$$$${d}/Makefile ]; then              \
			$(MAKE) $(MODULE)/$$$${d}/built;                        \
			[ $$$$? -ne 0 ] && {                                    \
				make $(MODULE)/$$$${d}/dirty;                       \
				exit 2;                                             \
			} || /bin/true;                                         \
		fi;                                                         \
	done

$(MODULE)/prepare:
	$(QUIET)for d in $(SUBDIRS);do                                  \
		cd $(TOPDIR);                                               \
		if [ -e $(MODULE_DIR)/$$$${d}/Makefile ]; then              \
			$(MAKE) $(MODULE)/$$$${d}/prepare;                      \
			[ $$$$? -ne 0 ] && exit 2 || /bin/true;                 \
		fi;                                                         \
	done

$(MODULE)/compile: $(MODULE)/prepare
	$(QUIET)for d in $(SUBDIRS);do                                  \
		cd $(TOPDIR);                                               \
		if [ -e $(MODULE_DIR)/$$$${d}/Makefile ]; then              \
			$(MAKE) $(MODULE)/$$$${d}/compile;                      \
			[ $$$$? -ne 0 ] && exit 2 || /bin/true;                 \
		fi;                                                         \
	done

$(MODULE)/install: $(MODULE)/compile
	$(QUIET)for d in $(SUBDIRS);do                                  \
		cd $(TOPDIR);                                               \
		if [ -e $(MODULE_DIR)/$$$${d}/Makefile ]; then              \
			$(MAKE) $(MODULE)/$$$${d}/install;                      \
			[ $$$$? -ne 0 ] && exit 2 || /bin/true;                 \
		fi;                                                         \
	done

$(MODULE)/clean:
	$(QUIET)for d in $(SUBDIRS);do                                  \
		cd $(TOPDIR);                                               \
		if [ -e $(MODULE_DIR)/$$$${d}/Makefile ]; then              \
			$(MAKE) $(MODULE)/$$$${d}/clean;                        \
			[ $$$$? -ne 0 ] && exit 2 || /bin/true;                 \
		fi;                                                         \
	done

.PHONY: $(MODULE)/prepare $(MODULE)/compile $(MODULE)/install $(MODULE)/uninstall
endef
endif
