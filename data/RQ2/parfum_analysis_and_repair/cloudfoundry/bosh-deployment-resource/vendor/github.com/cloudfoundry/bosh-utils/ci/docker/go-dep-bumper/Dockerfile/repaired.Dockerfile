FROM golang:1

# install basic utils {
RUN \
  apt-get update \
  && apt-get install --no-install-recommends -y \
    curl \
    git \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*
# }

# install dep {
RUN \
  tag="$( curl -f https://github.com/golang/dep/releases/latest | grep --only-matching -E 'v[0-9]+\.[0-9]+\.[0-9]+')" \
  && curl -f -L https://github.com/golang/dep/releases/download/$tag/dep-linux-amd64 -o /usr/bin/dep \
  && chmod a+x /usr/bin/dep
# }
