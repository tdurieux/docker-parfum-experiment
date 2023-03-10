FROM python:3-alpine

COPY . /nemesis
WORKDIR /nemesis

RUN set -ex \
 && pip install --no-cache-dir -e . \
 && rm -rf /root/.cache

RUN sed -i -- 's/host=localhost/host=mongodb/g' nemesis.cfg

ENTRYPOINT ["nemesis_api"]
CMD ["--conf", "nemesis.cfg"]
