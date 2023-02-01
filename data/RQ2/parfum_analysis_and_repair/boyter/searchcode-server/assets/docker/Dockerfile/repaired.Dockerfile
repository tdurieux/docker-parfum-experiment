FROM openjdk:8-jre

RUN apt-get update && apt-get install --no-install-recommends -y \
    curl \
    tar && rm -rf /var/lib/apt/lists/*;

RUN curl -f -o searchcode-server-community.tar.gz https://searchcode.com/static/searchcode-server-community.tar.gz \
    && tar zxvf searchcode-server-community.tar.gz && rm searchcode-server-community.tar.gz

WORKDIR /searchcode-server-community/release

EXPOSE 8080

CMD ["./searchcode-server.sh"]