#!/bin/bash

GATEWAY_IP="192.168.88.1"
PING_INTERVAL=60
PING_ATTEMPTS=3

Check_Ping() {
    for i in $(seq 1 $PING_ATTEMPTS); do
        if ping -c 1 -W 1 $GATEWAY_IP > /dev/null; then
            return 0
        fi
    done
    return 1
}
while true; do
    if ! Check_Ping; then
        echo "Шлюз $GATEWAY_IP недоступен. Перезагрузка роутера..."
        reboot
        exit 0
    else
        echo "Шлюз $GATEWAY_IP доступен."
    fi
    sleep $PING_INTERVAL
 done
