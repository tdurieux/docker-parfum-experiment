FROM hirocaster/docker-elixir

RUN mkdir /root/workspace

WORKDIR /root/workspace
COPY . /root/workspace

RUN apk add --no-cache python python-dev py-pip build-base
RUN pip install --no-cache-dir docker-compose

ENTRYPOINT [ \
  "prehook", \
    "elixir -v", \
    "docker-compose --version", \
    "mix deps.get", "--", \
  "switch", \
    "shell=/bin/sh", "--", \
  "codep", \
    "mix test" \
]
