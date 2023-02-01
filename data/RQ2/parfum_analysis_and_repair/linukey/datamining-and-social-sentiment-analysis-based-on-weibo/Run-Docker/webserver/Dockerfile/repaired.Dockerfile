FROM linukey/webserver

COPY server-tool.tgz /
COPY start-server.sh /

RUN cd / \
&&  tar -xzvf server-tool.tgz \
&&  rm server-tool.tgz \
&&  apt-get update \
&& apt-get install --no-install-recommends python3-pip -y \
&& pip3 install --no-cache-dir requests \
&& cd /usr/lib \
&& ln -s /usr/lib/python3.5/config-3.5m-x86_64-linux-gnu/libpython3.5.so libpython3.5.so && rm -rf /var/lib/apt/lists/*;
