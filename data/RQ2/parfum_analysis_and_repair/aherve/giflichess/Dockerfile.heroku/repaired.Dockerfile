FROM golang:1.16.5-stretch
RUN mkdir /app
WORKDIR /app

RUN apt update && apt install --no-install-recommends inkscape imagemagick git -y && rm -rf /var/lib/apt/lists/*;

ADD . .

RUN go build -o giflichess
