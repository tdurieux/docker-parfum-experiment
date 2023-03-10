FROM python:2.7.17-alpine3.11

RUN apk add --no-cache python2-dev \
                       iproute2 \
                       openssh \
                       bash \
                       bash-completion \
                       libffi-dev \
                       build-base \
                       openssl-dev \
                       vim

WORKDIR /usr/src/app

COPY . .

RUN pip install --no-cache-dir -r requirements.txt

CMD source scripts/start_bgpfs2acl.sh






