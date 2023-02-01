FROM python:3

ENV LANG C.UTF-8

# Copy data for add-on
COPY run.sh makeconf.sh rs485.py /

# Install requirements for add-on
RUN apt-get update && apt-get -y --no-install-recommends install jq && rm -rf /var/lib/apt/lists/*;
RUN python3 -m pip install pyserial && \
        python3 -m pip install paho-mqtt

WORKDIR /share

RUN chmod a+x /makeconf.sh
RUN chmod a+x /run.sh

CMD [ "/run.sh" ]

