FROM heroku/heroku:16

RUN apt-get update && apt-get install --no-install-recommends -y \
    gcc \
    python3-pip \
    libsm6 \
    build-essential \
    cmake \
    pkg-config \
    libx11-dev \
    libatlas-base-dev \
    libgtk-3-dev \
    libboost-python-dev && rm -rf /var/lib/apt/lists/*;

RUN cd /tmp && \
    wget -O ta-lib.tar.gz https://prdownloads.sourceforge.net/ta-lib/ta-lib-0.4.0-src.tar.gz && \
    tar xvzf ta-lib.tar.gz && \
    cd ta-lib && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix=/usr && \
    make && make install && rm ta-lib.tar.gz

ADD ./requirements.txt /tmp/requirements.txt

RUN pip3 install --no-cache-dir -r /tmp/requirements.txt

ADD ./ /opt/webapp/
WORKDIR /opt/webapp

CMD python3 main.py --test --strategy Doten
