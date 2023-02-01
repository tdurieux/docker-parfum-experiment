FROM rustembedded/cross:x86_64-unknown-linux-gnu-0.2.0

RUN apt-get update && \
    apt-get install --no-install-recommends -y libmysqlclient20 libmysqlclient-dev && \
    rm -rf /var/lib/apt/lists/*
