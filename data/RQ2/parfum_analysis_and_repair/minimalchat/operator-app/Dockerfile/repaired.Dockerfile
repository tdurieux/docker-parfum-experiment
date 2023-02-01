FROM node:11

RUN mkdir -p /tmp
WORKDIR /tmp/operator

## Run these together otherwise we have to remember to run it with --no-cache
#  occasionally
RUN dpkg --add-architecture i386 && \
      apt update && \
      apt install --no-install-recommends -y git build-essential wine wine32 libwine && rm -rf /var/lib/apt/lists/*;


RUN apt autoremove -y

COPY . .


# Build the scripts
RUN make clean dependencies

CMD ["make", "compile"]
