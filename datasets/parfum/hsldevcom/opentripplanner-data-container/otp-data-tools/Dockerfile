FROM openjdk:8-jre-buster
MAINTAINER Digitransit version: 0.1
ADD build-otp-data-tools.sh ${WORK}
VOLUME /data
RUN ./build-otp-data-tools.sh && rm build-otp-data-tools.sh
