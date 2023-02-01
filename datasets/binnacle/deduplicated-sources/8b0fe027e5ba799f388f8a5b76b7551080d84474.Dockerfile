FROM golang:stretch

# Install tools
RUN apt-get update \
    && apt-get -y -f dist-upgrade \
    && apt-get install -y -f \
        build-essential \
        linux-libc-dev \
        gcc-multilib \
        g++-multilib \
        vim \
        nano \
        git \
        file \
    && apt-get install -y -f \
        gcc-6-arm-linux-gnueabi \
        gcc-arm-none-eabi \
        gcc-arm-linux-gnueabi \
        binutils-arm-linux-gnueabi \
        g++-aarch64-linux-gnu \
    && ln -s /usr/include/asm-generic /usr/include/asm \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean -y

RUN useradd guest

# Install deps
RUN go get -u github.com/robfig/cron
RUN go get -u github.com/jessevdk/go-flags

RUN mkdir -p \
    /etc/cron.d/ \
    /etc/cron.daily/ \
    /etc/cron.hourly/ \
    /etc/cron.monthly/ \
    /etc/cron.weekly/ \
    && echo -n > /etc/crontab \
    && echo 'SHELL=/bin/sh' >> /etc/crontab \
    && echo 'PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin' >> /etc/crontab \
    && echo '' >> /etc/crontab \
    && echo '# m h dom mon dow user	command' >> /etc/crontab \
    && echo '17 *	* * *	root    cd / && run-parts --report /etc/cron.hourly' >> /etc/crontab \
    && echo '25 6	* * *	root	test -x /usr/sbin/anacron || ( cd / && run-parts --report /etc/cron.daily )' >> /etc/crontab \
    && echo '47 6	* * 7	root	test -x /usr/sbin/anacron || ( cd / && run-parts --report /etc/cron.weekly )' >> /etc/crontab \
    && echo '52 6	1 * *	root	test -x /usr/sbin/anacron || ( cd / && run-parts --report /etc/cron.monthly )' >> /etc/crontab \
    && echo '* *	* * *	root	date' >> /etc/crontab \
    && echo '' >> /etc/crontab

# Add some shell history
RUN set -x \
    && ln -sf /root/.ash_history /root/.bash_history \
    && echo go-crond -v root:examples/crontab-root guest:examples/crontab-guest >> /root/.ash_history \
    && echo go-crond -v examples/crontab >> /root/.ash_history \
    && echo go-crond -v --run-parts-1min=guest:examples/cron.daily/ >> /root/.ash_history \
    && echo go-crond -v --run-parts=10s:guest:examples/cron.daily/ >> /root/.ash_history \
    && echo go-crond -v --run-parts=10s:examples/cron.daily/ >> /root/.ash_history \
    && echo go-crond -v >> /root/.ash_history

# Copy source
COPY . /go/src/go-crond
WORKDIR /go/src/go-crond

# Build and install
RUN go build \
    && cp -a go-crond /usr/local/bin

CMD ["./go-crond"]
