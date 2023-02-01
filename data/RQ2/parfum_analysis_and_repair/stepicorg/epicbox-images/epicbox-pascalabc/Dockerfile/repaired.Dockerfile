FROM stepik/epicbox-mono:6.10.0
MAINTAINER Alexander Petrov <alexander.petrov@stepik.org>

RUN apt-get update && apt-get install --no-install-recommends wget unzip -y && \
    wget https://pascalabc.net/downloads/PABCNETC.zip -O /tmp/PABCNETC.zip && \
    mkdir /opt/pabcnetc && \
    unzip /tmp/PABCNETC.zip -d /opt/pabcnetc && \
    apt-get --purge remove wget unzip -y && \
    rm -rf /var/lib/apt/lists/* /tmp/*
