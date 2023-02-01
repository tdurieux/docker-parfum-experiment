FROM golang

RUN apt update && apt install --no-install-recommends -y pulseaudio alsa-utils libasound2-dev && rm -rf /var/lib/apt/lists/*;

WORKDIR /go/src/github.com/tuarrep/sounddrop
COPY . .

RUN go get

EXPOSE 19416

CMD ["go", "run", "main.go"]
