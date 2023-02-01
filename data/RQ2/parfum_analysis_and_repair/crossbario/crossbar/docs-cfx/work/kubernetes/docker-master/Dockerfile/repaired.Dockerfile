FROM ubuntu
RUN apt-get update && apt-get install --no-install-recommends -y curl && rm -rf /var/lib/apt/lists/*;
RUN mkdir /.crossbar
COPY crossbarfx /
COPY crossbarfx-ui.zip /.crossbar/.crossbarfx-ui.zip
RUN chmod a+x crossbarfx
EXPOSE 443
ENTRYPOINT ["./crossbarfx", "master", "start"]
