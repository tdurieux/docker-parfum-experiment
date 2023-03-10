FROM golang:1.11

RUN apt-get update -y && \
  apt-get install --no-install-recommends -y build-essential curl git libncurses5-dev python3-pip && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN pip3 install --no-cache-dir vim-vint

RUN useradd -ms /bin/bash -d /vim-go vim-go
USER vim-go

COPY . /vim-go/
WORKDIR /vim-go

RUN scripts/install-vim vim-7.4
RUN scripts/install-vim vim-8.0
RUN scripts/install-vim nvim

ENTRYPOINT ["make"]
