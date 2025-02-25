#!/bin/bash

IP1="192.168.1.100"
IP2="192.168.1.101"
Interface1="eth0"
Interface2="eth1"
Chat_ID="your_chat_id"
API_Token="your_telegram_bot_api_token"

send_telegram_message() {
	local message="$1"
	wget -q "https://api.telegram.org/bot$API_Token/sendMessage?chat_id=$Chat_ID&text=$message" > /dev/null 2>&1
}

check_interface() {
	local interface="$1"
	local ip="$2"
	local port_name="$3"

	mac_address=$(cat /sys/class/net/$interface/address 2>/dev/null)
	if [ "$mac_address"="" ]; then
	send_telegram_message "Нет подключения к порту $port_name ($interface)."
	return
	fi

	if ping -c 1 -W 1 "$ip" >/dev/null 2>&1; then
		echo "Устройство на порту $port_name ($interface) пингуется."
	else
		send_telegram_message "Связь на порту $port_name ($interface) есть (MAC: $mac_address), но устройство с IP $ip не пингуется."
	fi
}

check_interface "$Interface1" "$IP1" "Lan1"
check_interface "$Interface2" "$IP2" "Lan2"
