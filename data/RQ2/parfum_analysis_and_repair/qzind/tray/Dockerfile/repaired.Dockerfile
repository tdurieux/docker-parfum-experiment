FROM openjdk:11 as build
RUN apt-get update
RUN apt-get install --no-install-recommends -y ant nsis makeself && rm -rf /var/lib/apt/lists/*;
COPY . /usr/src/tray
WORKDIR /usr/src/tray
RUN ant makeself

FROM openjdk:11-jre as install
RUN apt-get update
RUN apt-get install --no-install-recommends -y libglib2.0-bin && rm -rf /var/lib/apt/lists/*;
COPY --from=build /usr/src/tray/out/*.run /tmp
RUN find /tmp -iname "*.run" -exec {} \;
WORKDIR /opt/qz-tray
ENTRYPOINT ["/opt/qz-tray/qz-tray"]