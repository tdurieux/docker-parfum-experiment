FROM tiangolo/uvicorn-gunicorn-fastapi:python3.8

WORKDIR /app

RUN git clone https://github.com/sstephenson/bats.git && \
    cd bats && \
    ./install.sh /usr/local

RUN apt-get update && apt-get install --no-install-recommends -y lsb-release && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y libncurses5 && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y vim && rm -rf /var/lib/apt/lists/*;
RUN wget https://repo.percona.com/apt/percona-release_latest.$(lsb_release -sc)_all.deb
RUN dpkg -i percona-release_latest.$(lsb_release -sc)_all.deb
RUN percona-release enable-only tools release
RUN apt-get update
RUN apt-get install --no-install-recommends -y percona-xtrabackup-80 && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y qpress && rm -rf /var/lib/apt/lists/*;

COPY ./ /app
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

RUN python3 setup.py install

ENV MODULE_NAME="api.main"
