FROM log2timeline/plaso

RUN apt-get update && \
    apt-get dist-upgrade -y

RUN apt-get install --no-install-recommends -y python-pip python-dev && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir pyelasticsearch
