#!/usr/bin/env bash
source <(curl -s https://raw.githubusercontent.com/C3dC0dgy/Proxmox-Scripts/main/misc/build.func)

function header_info {
  clear
  cat <<"EOF"
   ____                      __     
  / __ \____ ___  ____ _____/ /___ _
 / / / / __  __ \/ __  / __  / __  /
/ /_/ / / / / / / /_/ / /_/ / /_/ / 
\____/_/ /_/ /_/\__,_/\__,_/\__,_/  
 
EOF
}

header_info
echo -e "Loading..."
APP="Omada"
var_disk="8"
var_cpu="2"
var_ram="2048"
var_os="debian"
var_version="12"
variables
color
catch_errors

# Prompt for Omada version
prompt_omada_version() {
  echo -e "Please enter the Omada version you want to install (e.g., 5.9.31):"
  read -p "Version: " OMADA_VERSION
  if [[ -z "$OMADA_VERSION" ]]; then
    msg_error "No version entered. Exiting."
    exit 1
  fi
}

# Update script to install specified version
function update_script() {
  header_info
  if [[ ! -d /opt/tplink ]]; then 
    msg_error "No ${APP} Installation Found!"; 
    exit; 
  fi

  # Prompt for the version
  prompt_omada_version

  # Build the download URL
  base_url="https://static.tp-link.com"
  file_name="Omada_SDN_Controller_v${OMADA_VERSION}_Linux_x64.deb"
  OMADA_URL="${base_url}/${file_name}"

  # Download the specified version
  echo -e "Downloading Omada Controller version ${OMADA_VERSION}..."
  wget -qL "$OMADA_URL"
  if [[ $? -ne 0 ]]; then
    msg_error "Failed to download version ${OMADA_VERSION}. Please check the version and try again."
    exit 1
  fi
  msg_ok "Downloaded Omada Controller version ${OMADA_VERSION}."

  # Install the downloaded version
  echo -e "Installing Omada Controller version ${OMADA_VERSION}..."
  dpkg -i "$file_name"
  rm -f "$file_name"
  msg_ok "Installed Omada Controller version ${OMADA_VERSION}."
}

# Main execution
start
build_container
description

msg_ok "Completed Successfully!\n"
echo -e "${APP} should be reachable by going to the following URL:
         ${BL}https://${IP}:8043${CL} \n"
