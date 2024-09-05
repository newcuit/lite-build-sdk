#!/bin/bash

cd $TOPDIR

#set -x
function get_project_name(){
	local topdir="$1"
	local dirlist="$2"
	local depend_pkg="$3"

	for subdir in $dirlist; do
		grep "^ *config *${depend_pkg} *$" $topdir/${subdir}/Config.in >/dev/null 2>/dev/null
		[ $? -eq 0 ] && echo $subdir
	done
	echo ""
}

function parse_configin() {
	local dirlist
	local depends
	local project_name
	local configin="$1"

	depends=$(sed -nr 's/^.*depends on (.*)$/\1/p' $configin)
	[ -z "$depends" ] && return 0;

	depends_list=$(echo $depends | awk -F'[&&||]' '{
		for (i = 1;i <= NF; i++) {
			gsub(" ","",$i);
			gsub("\\(","",$i);
			gsub("\\)","",$i);
			printf $i " "
		}
	}')

	for depend_pkg in $depends_list;do
		for dir in package;do
			cd $TOPDIR/$dir;
			dirlist=$(find . -name Config.in | xargs dirname {} | sed -nr 's/\.\///p')
			[ -z "$dirlist" ] && continue;

			project_name=$(get_project_name "$TOPDIR/$dir" "$dirlist" "$depend_pkg")
			[ -z "$project_name" ] && continue;

			cd $TOPDIR; make $dir/${project_name}/built
			[ $? -ne 0 ] && exit 2;
			break;
		done
	done
}

[ -n "$1" ] && {
	parse_configin "$1"
}
