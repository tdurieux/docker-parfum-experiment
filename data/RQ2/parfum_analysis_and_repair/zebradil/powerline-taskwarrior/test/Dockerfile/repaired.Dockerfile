FROM python:3

WORKDIR /app

RUN --mount=type=cache,target=/var/cache/apt--mount=type=cache,target=/var/lib/apt \
    apt-get update \
 && apt-get install -y --no-install-recommends taskwarrior && rm -rf /var/lib/apt/lists/*;

COPY . .

RUN --mount=type=cache,target=/root/.cache/pip \
    pip install --no-cache-dir .

ENTRYPOINT [ "/bin/bash", "-c" ]

CMD [ "/app/test/test.sh" ]
