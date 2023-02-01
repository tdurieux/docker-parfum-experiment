FROM ubuntu

MAINTAINER snakesocks@mail.com

RUN apt update && apt install --no-install-recommends -y gcc g++ libboost-system-dev cmake make && rm -rf /var/lib/apt/lists/*;

RUN mkdir /app
COPY . /app
WORKDIR /app

RUN make clean native default_modules install
CMD ["bash", "-c", "echo 'Usage: docker run <this image> sksrv/skcli [args...]' ; exit 1"]

