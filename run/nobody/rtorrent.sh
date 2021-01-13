#!/bin/bash

# if rtorrent is already running then use xmlrpc to reconfigure
if [[ "${rtorrent_running}" == "false" ]]; then

	echo "[info] Removing any rTorrent session lock files left over from the previous run..."
	rm -f /rtbase/session/*.lock

	echo "[info] Attempting to start rTorrent..."

	# run tmux attached to rTorrent (daemonized, non-blocking)
	/usr/bin/script /home/nobody/typescript --command "/usr/bin/tmux new-session -d -s rt -n rtorrent /usr/bin/rtorrent"

	# make sure process rtorrent DOES exist
	retry_count=12
	retry_wait=1
	while true; do

		if ! pgrep -x "rtorrent main" > /dev/null; then

			retry_count=$((retry_count-1))
			if [ "${retry_count}" -eq "0" ]; then

				echo "[warn] Wait for rTorrent process to start aborted, too many retries" ; return 1

			else

				if [[ "${DEBUG}" == "true" ]]; then
					echo "[debug] Waiting for rTorrent process to start"
					echo "[debug] Re-check in ${retry_wait} secs..."
					echo "[debug] ${retry_count} retries left"
				fi
				sleep "${retry_wait}s"

			fi

		else

			echo "[info] rTorrent process started"
			break

		fi

	done

fi
