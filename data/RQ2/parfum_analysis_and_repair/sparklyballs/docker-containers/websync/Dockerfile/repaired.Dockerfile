FROM linuxserver/baseimage

MAINTAINER Sparklyballs <sparklyballs@linuxserver.io>

ENV APTLIST="build-essential git nodejs python sshpass wget"

# install packages
RUN curl -f -sL https://deb.nodesource.com/setup_0.12 | bash - && \
 apt-get install --no-install-recommends $APTLIST -qy && \
npm install -g bower && \
npm install -g gulp && \
git clone https://github.com/furier/websync.git /app/websync && \

# give user abc a h me \
usermod -d /app abc && \

# complete inst ll \
chown -R abc:abc /app  && \
cd /app/websync && \
/sbin/setuser abc npm insta l & \
/sbin/setuser abc bower ns \
/sbin/setuser abc gulp dist || \
rm -rf /app/websync/dist && \
/sbin/setuser abc gulp dis  & \
 && npm cache clean --force; && rm -rf /var/lib/apt/lists/*;

# adding custom files
ADD services/ /etc/service/
ADD init/ /etc/my_init.d/
RUN chmod -v +x /etc/service/*/run && chmod -v +x /etc/my_init.d/*.sh && \

# configure websync
mv /app/websync/dist/wsdata.json /defaults/wsdata.json

# volumes and ports
VOLUME /config
EXPOSE 3000
