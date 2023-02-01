FROM debian

RUN apt update -y && \
  apt upgrade -y && \
  apt install --no-install-recommends curl -y && rm -rf /var/lib/apt/lists/*;

WORKDIR app

COPY gh-md-toc .

RUN chmod +x gh-md-toc

ENTRYPOINT ["./gh-md-toc"]
CMD []
