#!/bin/bash

# define destination file path for rtorrent config file
rtorrent_config="/rtbase/rtorrent.rc"
rtorrent_rtlocal="/rtbase/_rtlocal.rc"

# if rtorrent rtorrent.rc file doesnt exist then copy default to host config volume
if [[ ! -f "${rtorrent_config}" ]]; then

	echo "[info] rTorrent rtorrent.rc file doesnt exist, copying default to /rtbase/"

	# copy default rtorrent.rc to /rtbase/
	cp /home/nobody/rtorrent/rtorrent.rc /rtbase/

else

	echo "[info] rTorrent rtorrent.rc file already exists, skipping copy"

fi

# if rtorrent _rtlocal.rc file doesnt exist then copy default to host config volume
if [[ ! -f "${rtorrent_rtlocal}" ]]; then

        echo "[info] rTorrent _rtlocal.rc file doesnt exist, copying default to /rtbase/"

        # copy default _rtlocal.rc to /rtbase/
        cp /home/nobody/rtorrent/_rtlocal.rc /rtbase/

else

        echo "[info] rTorrent _rtlocal.rc file already exists, skipping copy"

fi


# replace legacy rtorrent 0.9.6 config entries (rtorrent v0.9.7 does not allow entries below in rtorrent.rc)
sed -i -e 's~use_udp_trackers = yes~trackers.use_udp.set = yes~g' "${rtorrent_config}"
sed -i -e 's~use_udp_trackers = no~trackers.use_udp.set = no~g' "${rtorrent_config}"
sed -i -e 's~peer_exchange = yes~protocol.pex.set = yes~g' "${rtorrent_config}"
sed -i -e 's~peer_exchange = no~protocol.pex.set = no~g' "${rtorrent_config}"

# remove legacy rtorrent 0.9.6 config entries (rtorrent v0.9.7 does not allow entries below in rtorrent.rc)
sed -i '/system.file_allocate.set/d' "${rtorrent_config}"

# force unix line endings conversion in case user edited rtorrent.rc with notepad
/usr/local/bin/dos2unix.sh "${rtorrent_config}"

# create soft link to rtorrent config file
ln -fs "${rtorrent_config}" ~/.rtorrent.rc

# define sleep period between loops
sleep_period_secs=30

# define sleep period between incoming port checks
sleep_period_incoming_port_secs=1800

# sleep period counter - used to limit number of hits to external website to check incoming port
sleep_period_counter_secs=0

# while loop to check ip and port
while true; do

	# reset triggers to negative values
	rtorrent_running="false"

        # check if rtorrent is running, if not then start via rtorrent.sh
	if ! pgrep -x "rtorrent main" > /dev/null; then

	        echo "[info] rTorrent not running"

		# run script to start rtorrent
		source /home/nobody/rtorrent.sh

	else

		# mark as rtorrent as running
		rtorrent_running="true"

	fi

	# increment sleep period counter - used to limit number of hits to external website to check incoming port
	sleep_period_counter_secs=$((sleep_period_counter_secs+"${sleep_period_secs}"))

	sleep "${sleep_period_secs}"s

done
