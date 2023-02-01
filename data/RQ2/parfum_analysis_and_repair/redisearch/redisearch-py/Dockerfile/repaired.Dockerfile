FROM redislabs/redisearch:edge as builder

RUN apt update && apt install --no-install-recommends -y python3 python3-pip && rm -rf /var/lib/apt/lists/*;
ADD . /build
WORKDIR /build
RUN pip3 install --no-cache-dir poetry
RUN poetry config virtualenvs.create false
RUN poetry build

### clean docker stage
FROM redislabs/redisearch:edge as runner

RUN apt update && apt install --no-install-recommends -y python3 python3-pip git && rm -rf /var/lib/apt/lists/*;
RUN rm -rf /var/cache/apt/

COPY --from=builder /build/dist/redisearch*.tar.gz /tmp/
RUN pip3 install --no-cache-dir /tmp/redisearch*.tar.gz
