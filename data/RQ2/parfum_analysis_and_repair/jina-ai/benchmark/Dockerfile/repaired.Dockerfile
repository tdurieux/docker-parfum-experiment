ARG JINA_VER

FROM jinaai/jina:$JINA_VER

WORKDIR /app

ADD requirements.txt .

# install dependencies
RUN apt-get update && \
    apt-get install --no-install-recommends -y gcc && \
    pip3 install --no-cache-dir -r requirements.txt && rm -rf /var/lib/apt/lists/*;

# run benchmark
ENTRYPOINT ["pytest"]
