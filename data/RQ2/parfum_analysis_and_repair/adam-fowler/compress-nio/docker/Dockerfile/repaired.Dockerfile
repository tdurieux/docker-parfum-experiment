FROM swift:5.2 as builder

RUN apt-get -qq update && apt-get install --no-install-recommends -y \
  zlib1g-dev \
  && rm -r /var/lib/apt/lists/*
