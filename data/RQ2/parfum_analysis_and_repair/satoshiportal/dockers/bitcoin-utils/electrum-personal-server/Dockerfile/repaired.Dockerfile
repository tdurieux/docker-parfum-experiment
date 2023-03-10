FROM python:alpine

# Get belchers pubkey
RUN wget https://raw.githubusercontent.com/chris-belcher/electrum-personal-server/master/docs/pubkeys/belcher.asc

# Latest release of electum private server from https://github.com/chris-belcher/electrum-personal-server/releases
ENV VERSION 0.2.0

RUN wget https://github.com/chris-belcher/electrum-personal-server/releases/download/eps-v${VERSION}/eps-v${VERSION}.tar.gz.asc
RUN wget https://github.com/chris-belcher/electrum-personal-server/archive/eps-v${VERSION}.tar.gz

RUN apk add --no-cache gnupg
RUN gpg --batch --import belcher.asc
RUN gpg --batch --verify eps-v${VERSION}.tar.gz.asc eps-v${VERSION}.tar.gz && rm eps-v${VERSION}.tar.gz.asc

RUN tar -xvf eps-v${VERSION}.tar.gz && rm eps-v${VERSION}.tar.gz
RUN mv electrum-personal-server-eps-v${VERSION}/ eps

WORKDIR eps
RUN cp config.ini_sample config.ini

RUN pip3 install --no-cache-dir .
ENTRYPOINT ["electrum-personal-server"]
CMD ["./config.ini"]
