FROM ubuntu:16.04

ENV application_path /opt/anomalydetection

WORKDIR ${application_path}

COPY . .

RUN \
    apt-get update -y --allow-unauthenticated \
    && apt-get install --no-install-recommends -y \
        python3-dev \
        python3-pip \
        libsasl2-dev \
        libldap2-dev \
        libssl-dev \
        nodejs \
        npm && rm -rf /var/lib/apt/lists/*;

RUN ln -s /usr/bin/nodejs /usr/bin/node

RUN make

CMD python3 -m anomalydetection.anomdec
