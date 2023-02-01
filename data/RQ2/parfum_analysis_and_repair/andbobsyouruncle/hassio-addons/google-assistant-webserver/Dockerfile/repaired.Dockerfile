ARG BUILD_FROM
FROM $BUILD_FROM

# Install packages
RUN apt-get update && apt-get install --no-install-recommends -y jq tzdata python3 python3-dev python3-pip \
        python3-six python3-pyasn1 libportaudio2 alsa-utils && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir --upgrade pip
RUN pip3 install --no-cache-dir --upgrade six
RUN pip3 install --no-cache-dir --upgrade google-assistant-library google-auth \
        requests_oauthlib cherrypy flask flask-jsonpify flask-restful \
        grpcio google-assistant-grpc google-auth-oauthlib
RUN apt-get remove -y --purge python3-pip python3-dev
RUN apt-get clean -y
RUN rm -rf /var/lib/apt/lists/*

# Copy data
COPY run.sh /
COPY *.py /

RUN chmod a+x /run.sh

ENTRYPOINT [ "/run.sh" ]
