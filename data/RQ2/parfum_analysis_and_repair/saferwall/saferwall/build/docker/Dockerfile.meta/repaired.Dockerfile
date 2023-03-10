FROM debian:stretch-slim
LABEL maintainer="https://github.com/saferwall"
LABEL version="0.0.3"
LABEL description="saferwall static metadata extractor"

##### Install Prerequisites #####
RUN echo "Installing Prerequisites ..." \
    && apt-get update \
    && apt-get install -y -qq --no-install-recommends ca-certificates && rm -rf /var/lib/apt/lists/*;

##### Install dependencies #####
RUN echo "Installing Dependencies" \
    && buildDeps="automake unzip wget libtool make gcc pkg-config git" \
    && apt-get install -y $buildDeps --no-install-recommends && rm -rf /var/lib/apt/lists/*;

######## Installing TRiD ########
RUN echo "Installing TRiD..." \
    && wget https://mark0.net/download/trid_linux_64.zip -O /tmp/trid_linux_64.zip \
    && wget https://mark0.net/download/triddefs.zip -O /tmp/triddefs.zip \
    && cd /tmp \
    && unzip trid_linux_64.zip \
    && unzip triddefs.zip \
    && chmod +x trid \
    && mv trid /usr/bin/ \
    && mv triddefs.trd /usr/bin/

####### Installing Exiftool #######
ENV EXIF_VER 12.42
RUN echo "Installing Exiftool..." \
    && wget https://exiftool.org/Image-ExifTool-$EXIF_VER.tar.gz \
    && gzip -dc Image-ExifTool-$EXIF_VER.tar.gz | tar -xf - \
    && cd Image-ExifTool-$EXIF_VER \
    && perl Makefile.PL \
    && make test \
    && make install \
    && cd .. \
    && rm Image-ExifTool-$EXIF_VER.tar.gz \
	&& rm -r Image-ExifTool-$EXIF_VER

####### Installing File #######
RUN echo "Installing File..." \
    && apt-get install -y --no-install-recommends -qq file && rm -rf /var/lib/apt/lists/*;

####### Installing DiE #######
ENV DIE_VERSION     2.05
ENV DIE_URL         https://github.com/horsicq/DIE-engine/releases/download/$DIE_VERSION/die_lin64_portable_$DIE_VERSION.tar.gz
ENV DIE_ZIP         /tmp/die_lin64_portable_$DIE_VERSION.tar.gz
ENV DIE_DIR         /opt/die/

RUN echo "Installing DiE..." \
	&& apt-get install --no-install-recommends libglib2.0-0 -y \
	&& wget $DIE_URL -O $DIE_ZIP \
	&& tar zxvf $DIE_ZIP -C /tmp \
	&& mv /tmp/die_lin64_portable/ $DIE_DIR && rm -rf /var/lib/apt/lists/*;

####### Installing Yara #######
ENV YARA_VERSION        4.2.1
ENV YARA_ARCHIVE        $YARA_VERSION.tar.gz
ENV YARA_DOWNLOAD_URL   https://github.com/VirusTotal/yara/archive/v$YARA_ARCHIVE
ENV YARA_REPO_REPO      https://github.com/Yara-Rules/rules.git
ENV YARA_RULES_DIR      /opt/yararules

RUN echo "Installing Yara..." \
    && apt-get install --no-install-recommends libssl-dev libglib2.0-0 -y \
    && wget $YARA_DOWNLOAD_URL \
    && tar zxvf v$YARA_ARCHIVE \
    && cd ./yara-$YARA_VERSION \
    && ./bootstrap.sh \
    && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
    && make \
    && make install \
    && rm -rf ./yara-$YARA_VERSION \
    && rm -f $YARA_ARCHIVE \
    && git clone $YARA_REPO_REPO $YARA_RULES_DIR && rm -rf /var/lib/apt/lists/*;

####### Installing Capstone #######
RUN echo "Installing Capstone..." \
    && apt-get install --no-install-recommends libcapstone-dev -y && rm -rf /var/lib/apt/lists/*;

# Cleanup.
RUN rm -rf /tmp/* \
    && apt-get purge -y --auto-remove $buildDeps \
    && rm -rf /var/lib/apt/lists/*
