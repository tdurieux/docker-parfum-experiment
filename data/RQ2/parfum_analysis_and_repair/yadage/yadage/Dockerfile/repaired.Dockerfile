FROM alpine
RUN apk add --no-cache automake autoconf libtool \
             python3-dev musl-dev libffi-dev \
             curl ipset ipset-dev iptables iptables-dev libnfnetlink libnfnetlink-dev libnl3 libnl3-dev make musl-dev openssl openssl-dev \
             jq util-linux font-bitstream-type1 build-base graphviz-dev imagemagick graphviz
#pip
RUN curl -f https://bootstrap.pypa.io/get-pip.py | python3 -

#docker
RUN curl -f https://download.docker.com/linux/static/stable/x86_64/docker-18.03.1-ce.tgz | tar -xzvf - && \
    cp docker/docker /usr/local/bin && \
    rm -rf docker

#kubctl
RUN curl -f -LO https://storage.googleapis.com/kubernetes-release/release/v1.12.0/bin/linux/amd64/kubectl && \
    mv kubectl /usr/local/bin && \
    chmod +x /usr/local/bin/kubectl

#yadage
RUN pip install --no-cache-dir pydotplus kubernetes
ADD . /code
RUN pip install --no-cache-dir -e /code
