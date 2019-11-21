#!/bin/bash

# Adapted from github.com/NicolasBernaerts/ubuntu-scripts/blob/master/ubuntugnome/gnomeshell-extension-manage

cleanup() {
  rm -rf "$ext_description"
  rm -rf "$ext_zipfile"
  rm -rf "$ext_version"
}

trap cleanup EXIT

# static variables
extension_path="$HOME/.local/share/gnome-shell/extensions"
gnome_site="https://extensions.gnome.org"

# get Gnome version
target_version="$(gnome-shell --version | tr -cd "0-9." | cut -d'.' -f1,2)"
current_version="${target_version}"

# exit if no arguments given
[[ "$#" -lt 1 ]] && echo "No extension IDs given, exiting."

for extension_id in "$@"; do
  # skip if not a number
  [[ "$extension_id" -gt 0 ]] || continue

  ext_description=$(mktemp)
  ext_zipfile=$(mktemp)
  ext_version=$(mktemp)

  # get extension metadata
  wget \
    --quiet \
    --header='Accept-Encoding:none' \
    -O "${ext_description}" \
    "${gnome_site}/extension-info/?pk=${extension_id}"

  # get extension name
  extension_name=$(sed 's/^.*name[\": ]*\([^\"]*\).*$/\1/' "${ext_description}")

  printf "Installing extension %s...\n" "$extension_name"

  # get extension UUID
  extension_uuid=$(sed 's/^.*uuid[\": ]*\([^\"]*\).*$/\1/' "${ext_description}")

  # extract all available versions
  sed "s/\([0-9]*\.[0-9]*[0-9\.]*\)/\n\1/g" "${ext_description}" \
    | grep "pk" \
    | grep "version" \
    | sed "s/^\([0-9\.]*\).*$/\1/" \
    | sort -V > "${ext_version}"

  # look for latest version or for current one
  if [[ "${target_version}" == "latest" ]]; then
    version_available="$(tail -n 1 < "${ext_version}")"
  else
    version_available="$(grep "^${target_version}$" "${ext_version}")"
  fi

  # if no candidate version found, get the next one after current version
  if [[ "${version_available}" == "" ]]; then
	  # create a version list including current version
	  cp "${ext_version}" "${ext_description}" 
	  echo "${target_version}" >> "${ext_description}"

	  # sort by version and get next version available after current version
	  version_available=$(sort -V <<< "${ext_description}" | sed "1,/${target_version}/d" | head -n 1)
  fi

  # if candidate version has been found, install
  if [[ "${version_available}" != "" ]]; then
	  # get extension description
	  wget \
      --quiet \
      --header='Accept-Encoding:none' \
      -O "${ext_description}" \
      "${gnome_site}/extension-info/?pk=${extension_id}&shell_version=${version_available}"

	  # get extension download URL
	  extension_url=$(sed 's/^.*download_url[\": ]*\([^\"]*\).*$/\1/' "${ext_description}")

	  # download extension archive
	  wget \
      --quiet \
      --header='Accept-Encoding:none' \
      -O "${ext_zipfile}" \
      "${gnome_site}${extension_url}"

	  # unzip extension to installation folder
	  mkdir -p "${extension_path}/${extension_uuid}"
	  unzip -oq "${ext_zipfile}" -d "${extension_path}/${extension_uuid}"
	  chmod +r "${extension_path}/${extension_uuid}/"*
  else
	  printf "[Error] No available version of %s for Gnome Shell version %s found." \
      "${extension_name}" \
      "${current_version}"
  fi
done