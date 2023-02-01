FROM python:3.8.6-alpine3.12

ENV HOME /pycoin

RUN apk add --update --no-cache git jq su-exec \
 && cd / \
 && git clone https://github.com/Kexkey/pycoin.git \
 && mkdir /usr/local/lib/python3.8/site-packages/pycoin \
 && cp -rf pycoin/pycoin/* /usr/local/lib/python3.8/site-packages/pycoin \
 && rm -rf pycoin/*

COPY script/pycoin.sh ${HOME}/pycoin.sh
COPY script/requesthandler.sh ${HOME}/requesthandler.sh
COPY script/responsetoclient.sh ${HOME}/responsetoclient.sh
COPY script/startpycoin.sh ${HOME}/startpycoin.sh
COPY script/trace.sh ${HOME}/trace.sh
COPY script/ku /usr/local/bin/ku

WORKDIR ${HOME}

RUN chmod +x startpycoin.sh requesthandler.sh /usr/local/bin/ku

ENTRYPOINT ["su-exec"]
