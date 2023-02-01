FROM ubuntu:18.04

LABEL Description="TeamTalk for Android in Ubuntu 18.04"

RUN apt update
RUN apt install --no-install-recommends -y make git unzip curl && rm -rf /var/lib/apt/lists/*;
# Duplicate of /TeamTalk5/Build/Makefile:depend-ubuntu18-android
RUN apt install --no-install-recommends -y doxygen ninja-build junit4 cmake openjdk-11-jdk junit4 autoconf libtool pkg-config python p7zip-full && rm -rf /var/lib/apt/lists/*;
RUN mkdir /root/tt5dist
RUN curl -f https://dl.google.com/android/repository/android-ndk-r21e-linux-x86_64.zip -o /root/tt5dist/android-ndk.zip
RUN cd /root/tt5dist && unzip android-ndk.zip
