###############################################################################
#
#IMAGE:   Android SDK
#VERSION: 26.1.1
#
###############################################################################
FROM openjdk:8

###############################################################################
#MAINTAINER
###############################################################################
MAINTAINER LiuMiao <liumiaocn@outlook.com>

###############################################################################
#ENVIRONMENT VARS
###############################################################################
ENV ANDROID_HOME /usr/local/android
ENV PATH ${PATH}:${ANDROID_HOME}/tools:${ANDROID_HOME}/tools/bin:${ANDROID_HOME}/platform-tools

###############################################################################
# install gradle 
###############################################################################