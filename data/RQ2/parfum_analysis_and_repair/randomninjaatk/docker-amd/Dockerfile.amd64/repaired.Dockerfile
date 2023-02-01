FROM ghcr.io/linuxserver/baseimage-alpine:3.12 AS python

RUN apk add --no-cache build-base python3 python3-dev py3-pip musl-dev gcc && \
    echo "*********** install python packages ***********" && \
	pip install --no-cache-dir wheel && \
	pip wheel --wheel-dir=/root/wheels \
		yq \
		mutagen \
		r128gain \
		mediafile \
		confuse \
		requests \
		https://github.com/beetbox/beets/tarball/master \
		deemix

FROM ghcr.io/linuxserver/baseimage-alpine:3.12

# Add Python Wheels
COPY --from=python /root/wheels /root/wheels

ENV TITLE="Automated Music Downloader (AMD)"
ENV TITLESHORT="AMD"
ENV VERSION="1.1.10"
ENV MBRAINZMIRROR="https://musicbrainz.org"
ENV XDG_CONFIG_HOME="/config/deemix/xdg"
ENV DOWNLOADMODE="wanted"
ENV FALLBACKSEARCH="True"

RUN apk add --no-cache \
	bash \
	ca-certificates \
	curl \
	jq \
	flac \
	eyed3 \
    	opus-tools \
	python3 \
	findutils \
	py3-pip \
  musl-dev \
  gcc \
	ffmpeg && \
    echo "************ install python packages ************" && \
	pip install --no-cache-dir \
     --no-index \
     --find-links=/root/wheels \
		yq \
		mutagen \
		r128gain \
		mediafile \
		confuse \
		requests \
		https://github.com/beetbox/beets/tarball/master \
		deemix && \
	echo "************ setup dl client config directory ************" && \
	echo "************ make directory ************" && \
	mkdir -p "${XDG_CONFIG_HOME}/deemix"

    # copy local files
COPY root/ /

WORKDIR /config

# ports and volumes
VOLUME /config
