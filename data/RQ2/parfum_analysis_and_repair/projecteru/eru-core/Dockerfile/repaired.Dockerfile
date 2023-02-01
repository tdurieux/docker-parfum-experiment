FROM ubuntu:14.04
ENV DEBIAN_FRONTEND noninteractive
RUN cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install --no-install-recommends -y build-essential && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python-pip python-dev libmysqld-dev liblzma-dev zlib1g-dev git libffi-dev libssl-dev cmake && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y wget && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir pip --upgrade
RUN wget https://github.com/libgit2/libgit2/archive/v0.22.0.tar.gz && \
    tar xzf v0.22.0.tar.gz && \
    cd libgit2-0.22.0/ && \
    cmake . && \
    make && make install && rm v0.22.0.tar.gz
ADD eru-core /opt/eru-core
WORKDIR /opt/eru-core
RUN export LDFLAGS="-Wl,-rpath='/usr/local/lib',--enable-new-dtags $LDFLAGS" && pip install --no-cache-dir -r ./requirements.txt && python setup.py install
