#!/usr/bin/env bash

set -euo pipefail

GH_REPO="https://github.com/jfrog/jfrog-cli"
TOOL_NAME="jfrog-cli"
TOOL_TEST="jf --help"

fail() {
	echo -e "asdf-$TOOL_NAME: $*"
	exit 1
}

curl_opts=(-fsSL)

sort_versions() {
	sed 'h; s/[+-]/./g; s/.p\([[:digit:]]\)/.z\1/; s/$/.z/; G; s/\n/ /' |
		LC_ALL=C sort -t. -k 1,1 -k 2,2n -k 3,3n -k 4,4n -k 5,5n | awk '{print $2}'
}

list_github_tags() {
	git ls-remote --tags --refs "$GH_REPO" |
		grep -o 'refs/tags/.*' | cut -d/ -f3- |
		sed 's/^v//' # NOTE: You might want to adapt this sed to remove non-version strings from tags
}

list_all_versions() {
	# Use the github releases page since its much easier to parse then jfrog directly
	list_github_tags
}

download_release() {
	local VERSION FILENAME URL CLI_OS
	VERSION="$1"
	FILENAME="$2"
	CLI_OS="na"
	IS_WINDOWS=$(echo "${OSTYPE}" | grep -q msys)
	IS_MAC=$(echo "${OSTYPE}" | grep -q darwin)

	if [[ $IS_WINDOWS ]]; then
		CLI_OS="windows"
		URL="https://releases.jfrog.io/artifactory/jfrog-cli/v2-jf/${VERSION}/jfrog-cli-windows-amd64/jf.exe"
		FILENAME="${FILENAME}.exe"
	elif [[ $IS_MAC ]]; then
		CLI_OS="mac"
		if [[ $(uname -m) == 'arm64' ]]; then
			URL="https://releases.jfrog.io/artifactory/jfrog-cli/v2-jf/${VERSION}/jfrog-cli-mac-arm64/jf"
		else
			URL="https://releases.jfrog.io/artifactory/jfrog-cli/v2-jf/${VERSION}/jfrog-cli-mac-386/jf"
		fi
	else
		CLI_OS="linux"
		MACHINE_TYPE="$(uname -m)"
		case $MACHINE_TYPE in
		i386 | i486 | i586 | i686 | i786 | x86)
			ARCH="386"
			;;
		amd64 | x86_64 | x64)
			ARCH="amd64"
			;;
		arm | armv7l)
			ARCH="arm"
			;;
		aarch64)
			ARCH="arm64"
			;;
		s390x)
			ARCH="s390x"
			;;
		ppc64)
			ARCH="ppc64"
			;;
		ppc64le)
			ARCH="ppc64le"
			;;
		*)
			echo "Unknown machine type: $MACHINE_TYPE"
			exit 1
			;;
		esac
		URL="https://releases.jfrog.io/artifactory/jfrog-cli/v2-jf/${VERSION}/jfrog-cli-${CLI_OS}-${ARCH}/jf"
	fi

	echo "* Downloading $TOOL_NAME release $VERSION from $URL..."
	curl "${curl_opts[@]}" -o "$FILENAME" -C - "$URL" || fail "Could not download $URL"
}

install_version() {
	local install_type="$1"
	local version="$2"
	local install_path="${3%/bin}/bin"

	if [ "$install_type" != "version" ]; then
		fail "asdf-$TOOL_NAME supports release installs only"
	fi

	(
		mkdir -p "$install_path"
		chmod u+x "$ASDF_DOWNLOAD_PATH/$TOOL_NAME"
		cp "$ASDF_DOWNLOAD_PATH/$TOOL_NAME" "$install_path/jf"

		local tool_cmd
		tool_cmd="$(echo "$TOOL_TEST" | cut -d' ' -f1)"
		test -x "$install_path/$tool_cmd" || fail "Expected $install_path/$tool_cmd to be executable."

		echo "$TOOL_NAME $version installation was successful!"

		# Run the jfrog intro they suggest in their own install script
		"$install_path/$tool_cmd" intro
	) || (
		rm -rf "$install_path"
		fail "An error occurred while installing $TOOL_NAME $version."
	)
}
