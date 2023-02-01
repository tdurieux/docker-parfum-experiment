FROM xnat/rtlab-base:no-deps.20180917.1

COPY dependencies/bin /usr/local/bin
COPY dependencies/scripts /usr/local/scripts
COPY dependencies/lib /usr/local/lib
COPY dependencies/nil-tools/RELEASE /usr/local/bin
COPY dependencies/nil-tools/REFDIR /usr/local/etc/nil-atlases

COPY rtlab /usr/local/bin/rtlab
RUN chmod a+x /usr/local/bin/rtlab/rtlab_wrapper.sh

ENV RELEASE=/usr/local/bin REFDIR=/usr/local/etc/nil-atlases RTLAB_HOME=/usr/local/bin/rtlab
ENV PATH=/usr/local/scripts:${RTLAB_HOME}:${PATH}