FROM golang:1.15

RUN git clone https://github.com/pivotal-cf/om
RUN cd om && go build -o /usr/bin/om main.go
RUN apt-get update && \
    apt-get -y --no-install-recommends install gettext-base && \
    apt-get clean && rm -rf /var/lib/apt/lists/*;
