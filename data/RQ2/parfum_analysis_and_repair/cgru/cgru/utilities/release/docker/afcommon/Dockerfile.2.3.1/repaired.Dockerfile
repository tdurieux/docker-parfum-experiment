FROM ubuntu:18.04

ENV CGRU_VERSION=2.3.1 CGRU_UBUNTU_VERSION=18.04
LABEL maintainer="Alexandre Buisine <alexandrejabuisine@gmail.com>" cgru_version=$CGRU_VERSION

RUN apt-get -qq update \
 && DEBIAN_FRONTEND=noninteractive apt-get -yqq --no-install-recommends install \
 	curl \
 	libpq5 \
 	libpython2.7 \
 	libpython3.6 \
 	python3-sip \
 	tcpdump \
 	telnet \
 	imagemagick \
 	iputils-ping \
 && apt-get -yqq clean \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /tmp
RUN curl -f -Lks "https://downloads.sourceforge.net/project/cgru/${CGRU_VERSION}/cgru.${CGRU_VERSION}.ubuntu${CGRU_UBUNTU_VERSION}_amd64.tar.gz" | tar zxvf - \
 && dpkg -i cgru-common*.deb afanasy-common*.deb afanasy-server*.deb afanasy-render*.deb \
 && rm -rf *

ADD https://github.com/kreuzwerker/envplate/releases/download/v0.0.8/ep-linux /usr/local/bin/ep
COPY resources/docker-entrypoint.sh /usr/local/bin/
RUN chmod +rx /usr/local/bin/ep /usr/local/bin/docker-entrypoint.sh \
 && chown render /opt/cgru/afanasy/config_default.json /opt/cgru/config_default.json \
 && sed -i 's/"af_servername":".\+",/"af_servername":"${AF_SERVERNAME}",/' /opt/cgru/afanasy/config_default.json \
 && sed -i 's/"af_serverport":[0-9]\+,/"af_serverport":${AF_SERVERPORT},/' /opt/cgru/afanasy/config_default.json \
 && sed -i 's/"af_clientport":[0-9]\+,/"af_clientport":${AF_CLIENTPORT},/' /opt/cgru/afanasy/config_default.json \
 && sed -i 's/"af_thumbnail_extensions":.\+,/"af_thumbnail_extensions":${AF_THUMBNAIL_EXTENSIONS},/' /opt/cgru/afanasy/config_default.json \
 && sed -i 's/"af_thumbnail_cmd":".\+",/"af_thumbnail_cmd":"${AF_THUMBNAIL_CMD}",/' /opt/cgru/afanasy/config_default.json \
 && sed -i 's/"af_render_zombietime":.\+,/"af_render_zombietime":${AF_RENDER_ZOMBIETIME},/' /opt/cgru/afanasy/config_default.json \
 && sed -i 's/"af_render_connectretries":.\+,/"af_render_connectretries":${AF_RENDER_CONNECTRETRIES},/' /opt/cgru/afanasy/config_default.json \
 && sed -i 's/"cmd_shell":"\/bin\/sh -c"/"cmd_shell":"${CGRU_CMD_SHELL}"/' /opt/cgru/config_default.json

RUN mkdir /var/tmp/afanasy && chown render:render /var/tmp/afanasy
VOLUME /var/tmp/afanasy
ENV CGRU_CMD_SHELL="/bin/sh -c" \
 AF_USERNAME="render" \
 AF_SERVERNAME="afrender" \
 AF_SERVERPORT=51000 \
 AF_RENDER_ZOMBIETIME=60 \
 AF_RENDER_CONNECTRETRIES=3 \
 AF_THUMBNAIL_EXTENSIONS="[\"exr\",\"dpx\",\"jpg\",\"jpeg\",\"png\",\"tif\",\"tiff\",\"tga\"]" \
 AF_THUMBNAIL_CMD="convert -identify '%(image)s' %(pre_args)s -thumbnail '100x100^' -gravity center -extent 100x100 -colorspace sRGB '%(thumbnail)s'"
# ENV AF_HOSTNAME=""

WORKDIR /opt/cgru
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD ["/opt/cgru/afanasy/bin/afcmd"]