FROM ubuntu:18.04

RUN apt-get update && apt-get install --no-install-recommends -y librsvg2-bin && rm -rf /var/lib/apt/lists/*;

WORKDIR /convertor

ENTRYPOINT ["rsvg-convert"]
CMD ["-d", "300", "-p", "300"]