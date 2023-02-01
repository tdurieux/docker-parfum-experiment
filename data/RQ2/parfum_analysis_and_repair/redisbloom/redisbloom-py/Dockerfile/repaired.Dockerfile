FROM redislabs/rebloom:edge as builder

RUN apt update && apt install --no-install-recommends -y python3 python3-pip && rm -rf /var/lib/apt/lists/*;
ADD . /build
WORKDIR /build
RUN pip3 install --no-cache-dir poetry
RUN poetry config virtualenvs.create false
RUN poetry build

### clean docker stage
FROM redislabs/redisbloom:edge as runner

RUN apt update && apt install --no-install-recommends -y python3 python3-pip && rm -rf /var/lib/apt/lists/*;
RUN rm -rf /var/cache/apt/

COPY --from=builder /build/dist/redisbloom*.tar.gz /tmp/
RUN pip3 install --no-cache-dir /tmp/redisbloom*.tar.gz
