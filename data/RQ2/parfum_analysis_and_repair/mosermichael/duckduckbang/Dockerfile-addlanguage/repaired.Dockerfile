FROM alpine:3.12

ARG GITHUB_TOKEN=""

RUN apk add --no-cache bash python3 git expect py3-pip g++ libc-dev python3-dev linux-headers

RUN pip3 install --no-cache-dir fasttext
RUN pip3 install --no-cache-dir dataclasses-json

RUN wget https://dl.fbaipublicfiles.com/fasttext/supervised-models/lid.176.bin


COPY dcachebase.py /
COPY build_lang.py /
COPY description_cache.json /
COPY build/ex /
COPY build/build-lang-in-docker.sh /

CMD GITHUB_TOKEN=${GITHUB_TOKEN} ./build-lang-in-docker.sh
