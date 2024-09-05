#!/bin/bash

function dir_init() {
	for dir in package; do
		mkdir -p $PKG_CONFIGIN_DIR/$dir
	done
}

function config_init() {
	local dir="$1"

	rm -rf $PKG_CONFIGIN_DIR/$dir/Config.in
	for f in $(ls $TOPDIR/$dir);do
		[ -f $f ] && continue;
		[ -L  $f ] && continue;

		[ -e $TOPDIR/$dir/$f/Config.in ] && {
			echo "source \"$TOPDIR/$dir/$f/Config.in\"" >> $PKG_CONFIGIN_DIR/$dir/Config.in
		}
		echo
	done
	touch $PKG_CONFIGIN_DIR/$dir/Config.in
}

function configs_init() {
	for dir in package;do
		config_init "$dir"
	done
}

dir_init
configs_init
