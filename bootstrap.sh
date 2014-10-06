#!/usr/bin/env bash

# This is needed for version quering
yum install --assumeyes redhat-lsb-core

# Puppet manifests to execute
MANIFESTS=$*

# Figure out what distro, version and architecture we are running on
DISTRIBUTION=$(lsb_release -i -s)   # Fedora or CentOS
RELEASEVERSION=$(lsb_release -r -s) # 19,20,6.5,etc
RELEASEVERSION=${RELEASEVERSION%.*} # 19,20,6,etc (get rid of fractions)
EPELVERSION=8                       # epel-release-6-8, for example
BASEARCH=$(uname -i)                # i386 or x86_64

# Requirements for the puppet apply stage
REQUIREMENTS="git puppet"

case "$DISTRIBUTION" in
	"CentOS")
		# Install EPEL repository before requirements (for puppet)
		rpm -Uvh http://download.fedoraproject.org/pub/epel/$RELEASEVERSION/$BASEARCH/epel-release-$RELEASEVERSION-$EPELVERSION.noarch.rpm
		yum install --assumeyes $REQUIREMENTS
		;;
	"Fedora")
		yum install --assumeyes $REQUIREMENTS
		;;
	*)
		echo "Disribution $DISTRIBUTION is not supported."
		exit 1
		;;
esac

if [ -z "$MANIFESTS" ]
then
	echo "No puppet manifests were given, assuming minimal."
	MANIFESTS="minimal"
fi

rm -rf puppet-boxes
git clone https://github.com/mamchenkov/puppet-boxes.git && cd puppet-boxes
for MANIFEST in $MANIFESTS
do
	echo Applying puppet manifest "$MANIFEST"
	/usr/bin/sudo puppet apply --modulepath=modules/ manifests/${MANIFEST}.pp
done

