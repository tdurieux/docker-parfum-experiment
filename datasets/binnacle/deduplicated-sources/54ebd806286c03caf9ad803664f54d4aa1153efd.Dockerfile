MAINTAINER Selion <selion@googlegroups.com>

ENV DEBIAN_FRONTEND noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN true

#===================
# Timezone settings
# Possible alternative: https://github.com/docker/docker/issues/3359#issuecomment-32150214
#===================
ENV TZ "US/Pacific"
RUN echo "US/Pacific" | sudo tee /etc/timezone \
  && dpkg-reconfigure --frontend noninteractive tzdata

USER root

#==============
# Xvfb
#==============
RUN apt-get clean \
  && apt-get update -qqy \
  && apt-get -qqy install \
    xvfb \
  && rm -rf /var/lib/apt/lists/*

#==============================
# Scripts to run Selion Node
#==============================
COPY \
  entry_point.sh \
  functions.sh \
  $SELION_HOME/
RUN chmod +x $SELION_HOME/entry_point.sh

#============================
# Some configuration options
#============================
ENV SCREEN_WIDTH 1360
ENV SCREEN_HEIGHT 1020
ENV SCREEN_DEPTH 24
ENV DISPLAY :99.0

RUN chown -R seluser $SELION_HOME

USER seluser

CMD $SELION_HOME/entry_point.sh
