ARG base_image="python:3.9"

FROM ${base_image}

RUN mkdir /arouteserver
WORKDIR /arouteserver

RUN mkdir /bgpq4 && \
    cd /bgpq4 && \
    git clone https://github.com/bgp/bgpq4.git ./ && \
    git checkout tags/1.4 && \
    ./bootstrap && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && \
    make && \
    make install

ADD requirements.txt ./

RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir -r requirements.txt

COPY . ./
COPY docker/run.sh /root/run.sh
RUN pip install --no-cache-dir .

RUN arouteserver \
    setup --dest-dir /etc/arouteserver

RUN rm /etc/arouteserver/clients.yml

CMD /root/run.sh
