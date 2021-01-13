FROM binhex/arch-base:latest

MAINTAINER lethargynavigator

# additional files
##################

# add supervisor conf file for app
ADD build/*.conf /etc/supervisor/conf.d/

# add bash scripts to install app
ADD build/root/*.sh /root/

# add run bash scripts
ADD run/nobody/*.sh /home/nobody/

# add pre-configured config files for rtorrent
ADD config/nobody/ /home/nobody/

#ADD config/nobody/crontab /var/spool/cron/nobody

# install app
#############

# make executable and run bash scripts to install app
RUN chmod +x /root/*.sh /home/nobody/*.sh && \
	/bin/bash /root/install.sh

# docker settings
#################

# add pyrocore symlinks to path - symlinks from /opt/pyrocore to /home/nobody/bin
ENV PATH="${PATH}:/home/nobody/bin"

# map /rtbase to rtorrent-ps base path
VOLUME /rtbase

# map /config to host defined config path (used to store configuration from app)
VOLUME /config

# map /downloads to torrent downloads base path
VOLUME /downloads

# map /scgi to path containing scgi file
VOLUME /scgi

# set permissions
#################

# run script to set uid, gid and permissions
CMD ["/bin/bash", "/usr/local/bin/init.sh"]
