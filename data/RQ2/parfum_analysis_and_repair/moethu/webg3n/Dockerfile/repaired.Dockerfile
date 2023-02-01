# ######################################################################
# Docker container
# ######################################################################
FROM ubuntu:latest
LABEL maintainer="Bernhard Reitinger <br@rexos.org>"

ENV GO111MODULE=on

RUN apt-get update
ENV TZ=Europe/Vienna
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN apt-get install --no-install-recommends -y xorg-dev libgl1-mesa-dev libopenal1 libopenal-dev libvorbis0a libvorbis-dev libvorbisfile3 && rm -rf /var/lib/apt/lists/*;
RUN apt-get install -y --no-install-recommends libjpeg-turbo8 libjpeg-turbo8-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y xvfb && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y golang-1.14-go && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y ca-certificates && rm -rf /var/lib/apt/lists/*;

ENV PATH=$PATH:/usr/lib/go-1.14/bin

WORKDIR /go/src/app

COPY go.mod .
COPY go.sum .

RUN go mod download

COPY . .

RUN mkdir -p /go/bin

RUN GOOS=linux GOARCH=amd64 go build -ldflags="-s -w" -o /go/bin/web-app

WORKDIR /go/bin

RUN cp -r /go/src/app/templates /go/bin
RUN cp -r /go/src/app/static /go/bin
RUN cp -r /go/src/app/models /go/bin

EXPOSE 8000

ENTRYPOINT ["/bin/sh", "-c", "/usr/bin/xvfb-run -s \"-screen 0 1920x1080x24\" -a $@", ""]
CMD ["/go/bin/web-app"]