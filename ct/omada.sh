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

function update_script() {
  header_info
  if [[ ! -d /opt/tplink ]]; then 
    msg_error "No ${APP} Installation Found!"; 
    exit; 
  fi

  # Prompt for the version and build the URL
  prompt_omada_version
  build_omada_url
  download_omada_version

  # Install the specified version
  echo -e "Installing Omada Controller version ${OMADA_VERSION}..."
  dpkg -i "Omada_SDN_Controller_v${OMADA_VERSION}_Linux_x64.deb"
  rm -f "Omada_SDN_Controller_v${OMADA_VERSION}_Linux_x64.deb"
  msg_ok "Installed Omada Controller version ${OMADA_VERSION}."
}

start
build_container
description

msg_ok "Completed Successfully!\n"
echo -e "${APP} should be reachable by going to the following URL:
         ${BL}https://${IP}:8043${CL} \n"
