FROM gcr.io/skia-public/basealpine:3.8

USER root

COPY . /

USER skia

ENTRYPOINT ["/usr/local/bin/contest"]
