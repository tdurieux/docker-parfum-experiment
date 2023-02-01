FROM ubuntu:16.04
MAINTAINER Yannick Buron yburon@goclouder.net

# generate a locale and ensure it on system users
RUN locale-gen en_US.UTF-8 && update-locale && echo 'LANG="en_US.UTF-8"' > /etc/default/locale
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8
# add some system packages
RUN apt-get update && apt-get -y -q install \
        sudo less \
        net-tools \
        --no-install-recommends && rm -rf /var/lib/apt/lists/*;
RUN DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y vim ssmtp mailutils wget patch rsync ca-certificates && rm -rf /var/lib/apt/lists/*;
#/usr/bin/mail is used by shinken. I did all I could but I couldn't make it call ssmtp for the relay to postfix container.
#Be cautious to any application which also use it.
RUN rm /usr/bin/mail
RUN ln -s /usr/sbin/ssmtp /usr/bin/mail
#RUN echo "" > /etc/ssmtp/ssmtp.conf
