# DOCKER-VERSION 0.3.4
FROM node:18.3-slim
#FROM google/nodejs
#FROM node:4.4-wheezy
MAINTAINER  Emmanuel PIERRE epierre@e-nef.com
USER root
LABEL Description="This image is used to start the MyDomoAtHome executable" Vendor="Domoticz" Version="0.2.45"

##################################################
# Install tools                                  #
##################################################

RUN apt-get update --fix-missing
RUN apt-get -y --no-install-recommends install sudo && rm -rf /var/lib/apt/lists/*;
RUN useradd -m docker && echo "docker:docker" | chpasswd && adduser docker sudo
RUN apt-get install --no-install-recommends -yq curl && rm -rf /var/lib/apt/lists/*;
RUN rm /bin/sh && ln -s /bin/bash /bin/sh
RUN apt-get install -y --no-install-recommends tzdata && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install git git-core && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install wget curl && rm -rf /var/lib/apt/lists/*;

##################################################
# Set environment variables                      #
##################################################

RUN apt-get install --no-install-recommends -yq apt-utils && rm -rf /var/lib/apt/lists/*;
RUN apt-get install -y --no-install-recommends debconf && rm -rf /var/lib/apt/lists/*;
RUN apt-get update -qq && apt-get install --no-install-recommends -y locales -qq && locale-gen en_US.UTF-8 en_us && dpkg-reconfigure locales && dpkg-reconfigure locales && locale-gen C.UTF-8 && /usr/sbin/update-locale LANG=C.UTF-8 && rm -rf /var/lib/apt/lists/*;
# Ensure UTF-8
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8
ENV DEBIAN_FRONTEND noninteractive
ENV TERM xterm
ENV CONTAINER yes

##################################################
# Install MDAH                                   #
##################################################
# Set the time zone
RUN echo "Europe/Paris" > /etc/timezone && dpkg-reconfigure -f noninteractive tzdata
#VOLUME /etc/timezone /etc/localtime

##################################################
# Install MDAH                                   #
##################################################

#RUN cachebuster=b953b35 git clone -b nodejs https://github.com/empierre/MyDomoAtHome.git dist
#RUN cd MyDomoAtHome && bash run-once.sh
RUN curl -f -sL https://deb.nodesource.com/setup_12.x | bash -
RUN apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y npm && rm -rf /var/lib/apt/lists/*;
RUN npm install -g npm@6.x && npm cache clean --force;
RUN wget https://www.e-nef.com/domoticz/mdah/node-mydomoathome-0.2.50.deb
RUN dpkg --force-all -i node-mydomoathome-0.2.45.deb
RUN mv /etc/mydomoathome/config.json /etc/mydomoathome/config.json.old
VOLUME /etc/mydomoathome/

##################################################
# Start                                          #
##################################################

EXPOSE 3002

WORKDIR dist
ADD . dist
RUN rm /bin/sh && ln -s /bin/bash /bin/sh && \
  npm install -g forever nodemon mocha supervisor && npm cache clean --force;
#CMD ["forever", "start","--minUptime 1000 --spinSleepTime 1000 --max-old-space-size=128", "/usr/share/mydomoathome/app/mdah.js"]
RUN cd /usr/share/mydomoathome/app/
CMD ["forever", "/usr/share/mydomoathome/app/mdah.js"]
