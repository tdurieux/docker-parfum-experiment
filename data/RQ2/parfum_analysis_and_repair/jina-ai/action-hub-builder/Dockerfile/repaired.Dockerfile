FROM jinaai/jina

RUN apt-get update && apt-get install --no-install-recommends -y jq curl git && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir docker

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]