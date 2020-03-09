#!/bin/bash

#CRON: */5 * * * * root /home/joe/shutdown.sh

command=('/home/minecraft/ATM3Server.sh active'
'/home/minecraft/ATM5Server.sh active'
'/home/minecraft/VanillaServer.sh active'
'/home/steam/dst-master.sh active'
'/home/steam/dst-caves.sh active')

minimum_server_boot_time=3600

checkIfCommandReturnsFalse() {
	local isActive="$(${1})"
	if [ "$isActive" == "false" ]; then
		echo "true"
	else
		echo "false"
	fi
}

checkIfAnyCommandReturnsTrue() {
	for i in $(echo ${!command[@]}); do
		local isActive="$(checkIfCommandReturnsFalse "${command[$i]}")"
		if [ "$isActive" == "false" ]; then
			break
		fi
	done
	
	if [ "$isActive" == "false" ]; then
		echo "true"
	else
		echo "false"
	fi
}

checkActive() {
	local timeSinceBoot="$(printf '%.0f\n' "$(awk '{print $1}' /proc/uptime)")"
	
	if [ $minimum_server_boot_time -lt $timeSinceBoot ]; then
		local isActive="$(checkIfAnyCommandReturnsTrue)"
		if [ "$isActive" == "false" ]; then
			shutdown
		fi
	fi
}

checkActive