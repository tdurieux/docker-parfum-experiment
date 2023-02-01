FROM golang:1.16
RUN apt-get update && apt-get install --no-install-recommends -y git openssh-server tar gzip ca-certificates make curl gnupg && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y docker.io && rm -rf /var/lib/apt/lists/*;
RUN curl -f -sL https://deb.nodesource.com/setup_16.x | bash -
RUN apt-get -y --no-install-recommends install nodejs && rm -rf /var/lib/apt/lists/*;
#RUN go get -u github.com/gobuffalo/packr/v2/packr2
