#!/usr/bin/env bash
source <(curl -s https://raw.githubusercontent.com/tteck/Proxmox/main/misc/build.func)
# Copyright (c) 2021-2024 tteck
# Author: tteck (tteckster)
# License: MIT
# https://github.com/tteck/Proxmox/raw/main/LICENSE

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

function default_settings() {
  CT_TYPE="1"
  PW=""
  CT_ID=$NEXTID
  HN=$NSAPP
  DISK_SIZE="$var_disk"
  CORE_COUNT="$var_cpu"
  RAM_SIZE="$var_ram"
  BRG="vmbr0"
  NET="dhcp"
  GATE=""
  APT_CACHER=""
  APT_CACHER_IP=""
  DISABLEIP6="no"
  MTU=""
  SD=""
  NS=""
  MAC=""
  VLAN=""
  SSH="no"
  VERB="no"
  echo_default
}

function update_script() {
header_info
if [[ ! -d /opt/tplink ]]; then msg_error "No ${APP} Installation Found!"; exit; fi

# Specify the version of Omada you want to install
SPECIFIED_VERSION="5.9.31" # Change this to your desired version
base_url="https://static.tp-link.com"
file_name="Omada_SDN_Controller_v${SPECIFIED_VERSION}_Linux_x64.deb"
specified_url="${base_url}/${file_name}"

echo -e "Downloading Omada Controller version ${SPECIFIED_VERSION}"
wget -qL ${specified_url}
if [ $? -ne 0 ]; then
  msg_error "Failed to download version ${SPECIFIED_VERSION}. Please check the version and try again."
  exit
fi

echo -e "Installing Omada Controller version ${SPECIFIED_VERSION}"
dpkg -i ${file_name}
rm -rf ${file_name}
echo -e "Installed Omada Controller version ${SPECIFIED_VERSION}"
exit
}

start
build_container
description

msg_ok "Completed Successfully!\n"
echo -e "${APP} should be reachable by going to the following URL.
         ${BL}https://${IP}:8043${CL} \n"
