FROM ubuntu:bionic
COPY ["./dist/OFF_System_0.1.0_linux_amd64.deb", "./"]

EXPOSE 23402
EXPOSE 8200
ENV LD_LIBRARY_PATH="/usr/local/lib"
RUN apt-get update
RUN apt install --no-install-recommends libasound2 -y && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends "./OFF_System_0.1.0_linux_amd64.deb" -f -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get update -y && \
    apt-get install --no-install-recommends -y libgtk2.0-0 && \
    apt-get install --no-install-recommends -y libnotify-dev && \
    apt-get install --no-install-recommends -y libgconf-2-4 && \
    apt-get install --no-install-recommends -y libnss3 && rm -rf /var/lib/apt/lists/*;
ENV ELECTRON_RUN_AS_NODE="true"
ENTRYPOINT [ "offs", "/opt/offs/resources/app.asar/src/index.js", "--path", "/offs"]