FROM python:alpine

RUN apk add --no-cache -U git curl wget

WORKDIR /opt

RUN curl -f -s https://api.github.com/repos/hydrabus-framework/framework/releases/latest | grep "tarball_url" | cut -d '"' -f 4 | wget -qi - -O framework.tar.gz

RUN tar xvzf framework.tar.gz && rm framework.tar.gz && mv hydrabus* framework

WORKDIR framework

RUN python setup.py install

RUN hbfupdate

ENTRYPOINT ["hbfconsole"]
