FROM ubuntu:focal

EXPOSE 5000

ENV ASPNETCORE_ENVIRONMENT="Production"
ENV ASPNETCORE_URLS="http://*:5000"

RUN \
  apt-get -y update && \
  apt-get -y --no-install-recommends install \
  apt-utils \
  wget \
  apt-transport-https \
  unzip \
  acl \
  libssl1.0 && rm -rf /var/lib/apt/lists/*;

RUN \
  wget -q https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb && \
  dpkg -i packages-microsoft-prod.deb && \
  apt-get -y update && \
  apt-get -y --no-install-recommends install aspnetcore-runtime-5.0 && rm -rf /var/lib/apt/lists/*;

RUN \
  adduser --disabled-password --gecos '' -u 2001 remotely && \
  mkdir -p /var/www/remotely && \
  mkdir /config && \
  wget -q https://github.com/lucent-sea/Remotely/releases/latest/download/Remotely_Server_Linux-x64.zip && \
  unzip -o Remotely_Server_Linux-x64.zip -d /var/www/remotely && \
  rm Remotely_Server_Linux-x64.zip && \
  chown -R remotely:remotely /var/www/remotely

RUN \
  mkdir -p /remotely-data && \
  sed -i 's/DataSource=Remotely.db/DataSource=\/remotely-data\/Remotely.db/' /var/www/remotely/appsettings.json && \
  chown -R remotely:remotely /remotely-data

VOLUME "/remotely-data"

WORKDIR /var/www/remotely

COPY DockerMain.sh /

RUN chmod 755 /DockerMain.sh

USER remotely

ENTRYPOINT ["/DockerMain.sh"]
