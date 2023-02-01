FROM ubuntu
RUN apt update -y && apt install --no-install-recommends fortune fortunes -y && apt clean && rm -rf /var/lib/apt/lists/*;
COPY ./bin/apiserver /usr/local/bin/apiserver
ENTRYPOINT ["/usr/local/bin/apiserver"]
