#!/bin/bash

set -eu

#
# Meant to be run on the Synology only.
#

today="$(date +%Y-%m-%d)"
archive_dir="/root/certs/$today"
mkdir -p "$archive_dir" >/dev/null

if [[ ! -f /root/certs/fullchain.pem ]] || [[ ! -f /root/certs/privkey.pem ]]; then
  echo "ERROR: missing pem files"
  exit 1
fi

pushd /usr/syno/etc/certificate/_archive/ARKpqt >/dev/null
tar -czf "$archive_dir"/ARKpqt_"$today".tar.gz ./*.pem
cp /root/certs/*.pem .
popd >/dev/null

pushd /usr/syno/etc/certificate/smbftpd/ftpd >/dev/null
tar -czf "$archive_dir"/ftpd_"$today".tar.gz ./*.pem
cp /root/certs/*.pem .
popd >/dev/null

pushd /usr/local/etc/certificate/LogCenter/pkg-LogCenter >/dev/null
tar -czf "$archive_dir"/pkg-LogCenter_"$today".tar.gz ./*.pem
cp /root/certs/*.pem .
popd >/dev/null

pushd /usr/local/etc/certificate/CloudStation/CloudStationServer >/dev/null
tar -czf "$archive_dir"/CloudStationServer_"$today".tar.gz ./*.pem
cp /root/certs/*.pem .
popd >/dev/null

pushd /usr/local/etc/certificate/CardDAVServer/carddav >/dev/null
tar -czf "$archive_dir"/carddav_"$today".tar.gz ./*.pem
cp /root/certs/*.pem .
popd >/dev/null

pushd /usr/local/etc/certificate/VPNCenter/OpenVPN >/dev/null
tar -czf "$archive_dir"/OpenVPN_"$today".tar.gz ./*.pem
cp /root/certs/*.pem .
popd >/dev/null
