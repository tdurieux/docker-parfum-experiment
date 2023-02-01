FROM ubuntu:16.04

RUN apt-get update
RUN apt-get install --no-install-recommends -y build-essential && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y emacs && rm -rf /var/lib/apt/lists/*;

# Ruby
RUN apt-get install --no-install-recommends -y ruby && rm -rf /var/lib/apt/lists/*;

# Git
RUN apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y curl && rm -rf /var/lib/apt/lists/*;

COPY . /xiki/
RUN /xiki/bin/xsh --install

WORKDIR /root

CMD ["bash", "/xiki/bin/xsh"]

