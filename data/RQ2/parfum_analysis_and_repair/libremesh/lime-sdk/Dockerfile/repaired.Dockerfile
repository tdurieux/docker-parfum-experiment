FROM debian:latest

RUN apt-get update && apt-get install --no-install-recommends subversion build-essential libncurses5-dev zlib1g-dev gawk git ccache gettext libssl-dev xsltproc wget unzip python time -y && rm -rf /var/lib/apt/lists/*;

ADD . /app

WORKDIR /app

ENTRYPOINT ["/app/cooker"]
CMD ["--help"]
