#!/system/bin/sh
MODDIR=${0%/*}
#————————————————————————————#
# Execute script by tytydraco and his project ktweak, thanks!
#————————————————————————————#
write() {
	# Bail out if file does not exist
	[[ ! -f "$1" ]] && return 1
	
	# Make file writable in case it is not already
	chmod +w "$1" 2> /dev/null

	# Write the new value and bail if there's an error
	if ! echo "$2" > "$1" 2> /dev/null
	then
		echo "Failed: $1 → $2"
		return 1
	fi
}

sleep 60

#————————————————————————————#
#             Stop Dump & Diag                  #
#————————————————————————————#
su -c "stop tcpdump vendor.tcpdump vendor_tcpdump cnss_diag vendor.cnss_diag"

#————————————————————————————#
#              Clear Wifi Logs                     #
#————————————————————————————#
rm -rf /data/vendor/wlan_logs
touch /data/vendor/wlan_logs
chmod 000 /data/vendor/wlan_logs

exit 0