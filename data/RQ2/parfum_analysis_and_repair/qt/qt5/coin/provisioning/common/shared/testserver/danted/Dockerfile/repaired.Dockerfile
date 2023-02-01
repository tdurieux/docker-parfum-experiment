FROM qt_ubuntu_16.04
ARG packages="avahi-daemon"
RUN apt-get update && apt-get install --no-install-recommends -y $packages && dpkg -l $packages && rm -rf /var/lib/apt/lists/*;
COPY dante-server_1.4.1-1_amd64.deb .
RUN apt -y --no-install-recommends install ./dante-server_1.4.1-1_amd64.deb \
  && rm -f          ./dante-server_1.4.1-1_amd64.deb && rm -rf /var/lib/apt/lists/*;
EXPOSE 1080-1081

# install configurations and test data
COPY danted /etc/init.d/
COPY danted-authenticating /etc/init.d/
