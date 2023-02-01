FROM kamailio/kamailio:5.5.0-stretch

RUN apt-get update && apt-get install -y --no-install-recommends \
    python3 python3-pip \
    kamailio-sqlite-modules \
    && apt autoremove -y \
    && apt autoclean -y && rm -rf /var/lib/apt/lists/*;

RUN pip3 install --no-cache-dir --upgrade pip
RUN pip3 install --no-cache-dir --upgrade setuptools
RUN pip3 install --no-cache-dir requests httplib2 pysqlite3

WORKDIR /etc/kamailio/

RUN mkdir /usr/local/etc/kamailio

EXPOSE 5060

ENTRYPOINT ["kamailio", "-DD", "-E"]

