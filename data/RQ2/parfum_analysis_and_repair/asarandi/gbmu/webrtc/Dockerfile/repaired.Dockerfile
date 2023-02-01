FROM golang:alpine

WORKDIR /app

COPY ./ ./

RUN apk add --no-cache --update build-base gcc gstreamer-dev gst-plugins-base-dev gst-plugins-good gst-plugins-ugly && go build -o gbmu

EXPOSE 8080

CMD [ "./gbmu" ]
