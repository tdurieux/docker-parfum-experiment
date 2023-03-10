#Download go-auto-yt via git and youtube-dl via curl on ubuntu temp image
FROM ubuntu:latest as DOWNLOAD
WORKDIR /git
ARG TRAVIS_PULL_REQUEST=$TRAVIS_PULL_REQUEST
RUN apt-get update && apt-get install --no-install-recommends git curl xz-utils -y && rm -rf /var/lib/apt/lists/*;
RUN curl -f -L https://yt-dl.org/downloads/latest/youtube-dl -o ./youtube-dl && chmod a+rx ./youtube-dl
RUN git clone https://github.com/XiovV/go-auto-yt.git
RUN cd go-auto-yt && if [ ! "$TRAVIS_PULL_REQUEST" = false ]; then git fetch origin +refs/pull/"$TRAVIS_PULL_REQUEST"/merge && git checkout FETCH_HEAD ; fi

#Transfer git content from DOWNLOAD stage over GO stage to build application
FROM golang:alpine as GO
WORKDIR /app
COPY --from=DOWNLOAD /git/go-auto-yt .
RUN GOOS=linux GOARCH=arm64 go build -o main .

#Use alpine as base image and copy executable from other temp images
FROM alpine:latest as BASE
WORKDIR /app
COPY --from=GO /app/main .
COPY --from=GO /app/static ./static
COPY --from=GO /app/entrypoint.sh .
COPY --from=DOWNLOAD /git/youtube-dl /usr/local/bin/
RUN apk --update --no-cache add python shadow ffmpeg
RUN addgroup -S goautoyt
RUN adduser --system goautoyt --ingroup goautoyt

#Set starting command
ENTRYPOINT ["./entrypoint.sh"]

#Expose port and volumes
EXPOSE 8080
VOLUME /app/downloads
VOLUME /app/config