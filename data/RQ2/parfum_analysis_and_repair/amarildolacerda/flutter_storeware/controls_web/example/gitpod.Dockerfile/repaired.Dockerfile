FROM gitpod/workspace-full-vnc

ENV ANDROID_HOME=/workspace/android-sdk \
    FLUTTER_ROOT=/workspace/flutter \
    FLUTTER_HOME=/workspace/flutter

USER root

RUN apt-get update && \
    apt-get -y --no-install-recommends install build-essential libkrb5-dev gcc make gradle openjdk-8-jdk && \
    apt-get clean && \
    apt-get -y autoremove && rm -rf /var/lib/apt/lists/*;


# Install Chrome
RUN wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
RUN dpkg -i google-chrome-stable_current_amd64.deb; apt-get -fy install

