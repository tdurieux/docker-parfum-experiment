###############################################################################
#
#IMAGE:   Android SDK
#VERSION: 26.1.1
#         Gradle: 6.0.1
#         JDK     1.8
#
###############################################################################
FROM liumiaocn/gradle:jdk8.6.0.1

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