FROM python:3
MAINTAINER greenmind.sec@gmail.com
RUN apt-get update -y \
 && apt-get install --no-install-recommends python3-pip git -y \
 && git clone https://github.com/maurosoria/dirsearch.git \
 && cd /dirsearch \
 && chmod +x dirsearch.py && rm -rf /var/lib/apt/lists/*;

ADD default.conf .

WORKDIR /dirsearch

ENTRYPOINT ["./dirsearch.py"]
CMD ["--help"]
