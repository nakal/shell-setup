#!/bin/sh

check_packages_FreeBSD() {
	pkg info $REQUIRED_PACKAGES_FreeBSD > /dev/null
	if [ $? -ne 0 ]; then
		echo "ERROR: Missing required packages."
		exit 1
	fi
	echo "Checking recommended packages..."
	pkg info $RECOMMENDED_PACKAGES_FreeBSD > /dev/null
	if [ $? -ne 0 ]; then
		echo "WARNING: Some recommended packages are not installed."
	fi
}

parse_package_list_OpenBSD() {
	ret=0
	tmpfile=$1
	shift
	for pkg in $@; do
		if ! egrep -q "^$pkg" "$tmpfile"; then
			echo "*** System installation missing package $pkg"
			ret=1
		else
			echo "-> $pkg is installed"
		fi
	done

	return $ret
}

check_packages_OpenBSD() {
	tmpfile=`mktemp -t nakal_shell_setup.XXXXXX`
	pkg_info -aq > "$tmpfile"
	parse_package_list_${OS} $tmpfile $REQUIRED_PACKAGES_OpenBSD
	if [ $? -ne 0 ]; then
		echo "ERROR: missing required packages"
		rm "$tmpfile"
		exit 1
	fi

	echo "Checking recommended packages..."
	parse_package_list_${OS} $tmpfile $RECOMMENDED_PACKAGES_OpenBSD
	if [ $? -ne 0 ]; then
		echo "WARNING: missing recommended packages"
	fi

	rm "$tmpfile"
}

check_packages() {
	if [ "$OS" = "FreeBSD" ] || [ "$OS" = "OpenBSD" ]; then
		echo "Checking required packages..."
		check_packages_${OS}
	else
		echo "WARNING: Skipped checking packages..."
	fi
	return 0
}
