FROM ubuntu:20.04
RUN apt-get update && apt-get install --no-install-recommends -y curl && rm -rf /var/lib/apt/lists/*;

CMD ["--silent", "http://httpbin.org/get"]
ENTRYPOINT ["curl"]
