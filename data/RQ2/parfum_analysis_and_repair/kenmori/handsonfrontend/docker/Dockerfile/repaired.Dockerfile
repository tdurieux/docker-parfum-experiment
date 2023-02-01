FROM ubuntu:latest
RUN apt-get update && apt-get install --no-install-recommends -y \
    curl \
    nginx && rm -rf /var/lib/apt/lists/*;
RUN mkdir created_dockerfile

CMD ["--help"]
