#!/bin/bash

#
# Script to install the honeycomb server repo onto an
# Enterprise Linux or Fedora Core based system.
#
# Run as root or insert `sudo -E` before `bash`:
#
#
if test "`whoami`" != "root" ; then
        echo "You must be logged in as root to install (for create folder and add user admin)"
        echo "Enter 'su' or 'sudo bash' to switch to root"
        exit
fi

print_status() {
  local outp=$(echo "$1" | sed -r 's/\\n/\\n## /mg')
  echo
  echo -e "## ${outp}"
  echo
}

bail() {
  echo 'Error executing command, exiting'
  exit 1
}

exec_cmd_nobail() {
  echo "+ $1"
  bash -c "$1"
}

exec_cmd() {
  exec_cmd_nobail "$1" || bail
}

print_status "Installing the honeycomb server..."

print_status "Inspecting system..."

if [ ! -x /bin/rpm ]; then
  print_status "\
You don't appear to be running an Enterprise Linux based \
system\
"
  exit 1
fi


## Check distro and arch
echo "+ rpm -q --whatprovides redhat-release || rpm -q --whatprovides centos-release || rpm -q --whatprovides cloudlinux-release || rpm -q --whatprovides sl-release"
DISTRO_PKG=$(rpm -q --whatprovides redhat-release || rpm -q --whatprovides centos-release || rpm -q --whatprovides cloudlinux-release || rpm -q --whatprovides sl-release)
echo "+ uname -m"
UNAME_ARCH=$(uname -m)


if [ "X${UNAME_ARCH}" == "Xi686" ]; then
  DIST_ARCH=i386
elif [ "X${UNAME_ARCH}" == "Xx86_64" ]; then
  DIST_ARCH=x86_64
else

  print_status "\
You don't appear to be running a supported machine architecture: ${UNAME_ARCH}. \
"
  exit 1

fi

if [[ $DISTRO_PKG =~ ^(redhat|centos|cloudlinux|sl)- ]]; then
    DIST_TYPE=el
elif [[ $DISTRO_PKG =~ ^system-release- ]]; then # Amazon Linux
    DIST_TYPE=el
elif [[ $DISTRO_PKG =~ ^(fedora|korora)- ]]; then
    DIST_TYPE=fc
else

  print_status "\
You don't appear to be running a supported version of Enterprise Linux.  \
"
  exit 1

fi

if [[ $DISTRO_PKG =~ ^system-release-201[4-9]\. ]]; then  #NOTE: not really future-proof

  # Amazon Linux, for 2014.* use el7, older versions are unknown, perhaps el6
  DIST_VERSION=7

else

  ## Using the redhat-release-server-X, centos-release-X, etc. pattern
  ## extract the major version number of the distro
  DIST_VERSION=$(echo $DISTRO_PKG | sed -r 's/^[[:alpha:]]+-release(-server|-workstation)?-([0-9]+).*$/\2/')

  if ! [[ $DIST_VERSION =~ ^[0-9][0-9]?$ ]]; then

    print_status "\
Could not determine your distribution version, you may not be running a \
supported version of Enterprise Linux.\
"
    exit 1

  fi

fi



RELEASE_URL_VERSION_STRING="${DIST_TYPE}${DIST_VERSION}"
# RELEASE_URL="\
# https://rpm.nodesource.com/pub_8.x/\
# ${DIST_TYPE}/\
# ${DIST_VERSION}/\
# ${DIST_ARCH}/\
# nodesource-release-${RELEASE_URL_VERSION_STRING}-1.noarch.rpm"
RELEASE_URL="https://github-production-release-asset-2e65be.s3.amazonaws.com/114438106/36aa7902-0cd0-11e8-8f38-c23137077b3c?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAIWNJYAX4CSVEH53A%2F20180208%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20180208T050628Z&X-Amz-Expires=300&X-Amz-Signature=593e67babee0a2581cb4c510044c871927943c7802cebc2496d1ad12d1ff5c3d&X-Amz-SignedHeaders=host&actor_id=5602416&response-content-disposition=attachment%3B%20filename%3Dhoneycomb-server-1.0.1-0.el7.centos.x86_64.rpm&response-content-type=application%2Foctet-stream"

print_status "Confirming \"${DIST_TYPE}${DIST_VERSION}-${DIST_ARCH}\" is supported..."

## Simple fetch & fast-fail to see if the nodesource-release
## file exists for this distro/version/arch
exec_cmd_nobail "curl -sLf -o /dev/null '${RELEASE_URL}'"
RC=$?

if [[ $RC != 0 ]]; then
    print_status "\
Your distribution, identified as \"${DISTRO_PKG}\", \
is not currently supported"
    exit 1
fi


print_status "Downloading release setup RPM..."

## Download to a tmp file then install it directly with `rpm`.
## We don't rely on RPM's ability to fetch from HTTPS directly
echo "+ mktemp"
RPM_TMP=$(mktemp || bail)

exec_cmd "curl -sL -o '${RPM_TMP}' ${RELEASE_URL}"

print_status "Installing release setup RPM..."

exec_cmd "rpm -i --nosignature --force '${RPM_TMP}'"

print_status "Cleaning up..."

exec_cmd "rm -f '${RPM_TMP}'"

echo "+ install fininsh"
exit 0