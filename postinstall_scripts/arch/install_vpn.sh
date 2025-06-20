if [ -f "/opt/cisco/secureclient/bin/vpnui" ]; then
    return
fi

local url='https://vpn1.ntnu.no/cisco-secure-client-linux64-5.1.4.74-core-vpn-webdeploy-k9.sh'

cd "$REPOS_DIR"
wget "$url" 1> "$LOGFILE"
if [ -f "$url" ]; then
    bash 'cisco-secure-client-linux64-5.1.4.74-core-vpn-webdeploy-k9.sh'
else
    log "Failed to install Cisco VPN"
fi
