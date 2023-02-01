FROM python:3.9-slim
MAINTAINER Soxoj <soxoj@protonmail.com>
WORKDIR /app
RUN pip install --no-cache-dir --upgrade pip
RUN apt update && \
	apt install --no-install-recommends -y \
      gcc \
      musl-dev \
      libxml2 \
      libxml2-dev \
      libxslt-dev && rm -rf /var/lib/apt/lists/*;
RUN apt clean \
    && rm -rf /var/lib/apt/lists/* /tmp/*
ADD . .
RUN YARL_NO_EXTENSIONS=1 python3 -m pip install .
ENTRYPOINT ["maigret"]
