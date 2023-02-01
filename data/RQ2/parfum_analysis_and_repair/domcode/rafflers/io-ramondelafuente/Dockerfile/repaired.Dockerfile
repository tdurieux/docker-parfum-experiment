FROM debian:jessie

ENV DEBIAN_FRONTEND noninteractive
ENV LANG C.UTF-8

RUN apt-get update
RUN apt-get install --no-install-recommends -y wget && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y unzip && rm -rf /var/lib/apt/lists/*;

RUN mkdir -p /app

WORKDIR /app
RUN wget https://iobin.suspended-chord.info/linux/iobin-linux-x64-deb-current.zip 2>&1 && unzip iobin-linux-x64-deb-current.zip 2>&1 && dpkg -i /app/IoLanguage-2013.11.04-Linux-x64.deb

COPY raffler.io /app/

# Run raffler
CMD ["io", "/app/raffler.io", "/var/names.txt"]
