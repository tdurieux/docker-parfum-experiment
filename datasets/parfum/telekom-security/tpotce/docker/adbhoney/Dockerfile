FROM alpine:3.16
#
# Include dist
COPY dist/ /root/dist/
#
# Install packages
RUN apk --no-cache -U add \
            git \
	    procps \
            python3 && \
#
# Install adbhoney from git
    git clone https://github.com/huuck/ADBHoney /opt/adbhoney && \
    cd /opt/adbhoney && \
#    git checkout ad7c17e78d01f6860d58ba826a4b6a4e4f83acbd && \
    git checkout 2417a7a982f4fd527b3a048048df9a23178767ad && \
    cp /root/dist/adbhoney.cfg /opt/adbhoney && \
    sed -i 's/dst_ip/dest_ip/' /opt/adbhoney/adbhoney/core.py && \
    sed -i 's/dst_port/dest_port/' /opt/adbhoney/adbhoney/core.py && \
#
# Setup user, groups and configs
    addgroup -g 2000 adbhoney && \
    adduser -S -H -s /bin/ash -u 2000 -D -g 2000 adbhoney && \
    chown -R adbhoney:adbhoney /opt/adbhoney && \
#
# Clean up
    apk del --purge git && \
    rm -rf /root/* /opt/adbhoney/.git /var/cache/apk/*
#
# Set workdir and start adbhoney
STOPSIGNAL SIGINT
# Adbhoney sometimes hangs at 100% CPU usage, if detected process will be killed and container restarts per docker-compose settings
HEALTHCHECK CMD if [ $(ps -C mpv -p 1 -o %cpu | tail -n 1 | cut -f 1 -d ".") -gt 75 ]; then kill -2 1; else exit 0; fi
USER adbhoney:adbhoney
WORKDIR /opt/adbhoney/
CMD /usr/bin/python3 run.py
