FROM debian:buster@sha256:e2cc6fb403be437ef8af68bdc3a89fd58e80b4e390c58f14c77c466002391193
COPY buster_deps.sh /deps.sh
RUN /deps.sh && rm /deps.sh
VOLUME /wallycore
ENV JAVA_HOME=/usr/lib/jvm/java-1.11.0-openjdk-amd64
ENV ANDROID_NDK=/opt/android-ndk-r21d