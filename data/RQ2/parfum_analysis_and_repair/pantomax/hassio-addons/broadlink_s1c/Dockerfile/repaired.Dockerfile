ARG BUILD_FROM
FROM $BUILD_FROM

# Add env
ENV LANG C.UTF-8
RUN apk add --no-cache \
        jq \
        py2-pip \
        clang \
        libgcc \
        gcc-gnat \
        libgc++ \
        g++ \
        make \
        libffi-dev \
        openssl-dev \
        python2-dev \
        mosquitto \
        mosquitto-dev \
        mosquitto-libs \
        mosquitto-clients

RUN pip install --no-cache-dir pyaes
RUN pip install --no-cache-dir broadlink
RUN pip install --no-cache-dir pycrypto

RUN apk add --no-cache \
        jq \
        py-pip \
        python \
        python-dev \
        python3 \
        mosquitto \
        mosquitto-clients \
        python3-dev \
&& pip install --no-cache-dir -U pip \
&& pip3 install --no-cache-dir -U pip \
&& pip install --no-cache-dir -U virtualenv

# Copy data for add-on
COPY run.sh /
RUN chmod a+x /run.sh

CMD [ "/run.sh" ]