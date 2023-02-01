FROM java:8-jre
COPY chainspaceapi /app/chainspaceapi
COPY chainspacecontract /app/chainspacecontract
COPY chainspacecore /app/chainspacecore
COPY contrib /app/contrib
COPY Makefile /app/
RUN apt-get update
RUN apt-get install -y --no-install-recommends screen && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install virtualenv && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install python && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install python-setuptools && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install build-essential libssl-dev libffi-dev python-dev && rm -rf /var/lib/apt/lists/*;
RUN easy_install pip
WORKDIR /app
RUN virtualenv .chainspace.env
RUN . .chainspace.env/bin/activate && pip install --no-cache-dir -U setuptools
RUN . .chainspace.env/bin/activate && pip install --no-cache-dir -e ./chainspaceapi
RUN . .chainspace.env/bin/activate && pip install --no-cache-dir -e ./chainspacecontract
RUN . .chainspace.env/bin/activate && pip install --no-cache-dir petlib
CMD make start-nodes && make start-client-api

