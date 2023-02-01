FROM ubuntu:latest
RUN apt update && apt-get install --no-install-recommends ca-certificates -y && rm -rf /var/lib/apt/lists/*;
RUN apt -y  upgrade

RUN update-ca-certificates
ENV APP_BINARY=/usr/local/bin/filebin2
COPY ./filebin2 $APP_BINARY
ENV HOME=/home/filebin2
RUN mkdir -p $HOME
RUN mkdir -p /var/log/filebin
ENV USER_ID=1024
ENV GROUP_ID=1024
RUN addgroup --gid $GROUP_ID filebin2
RUN useradd --system --uid $USER_ID --gid $GROUP_ID --shell /bin/bash --home $HOME filebin2
RUN chown -R filebin2:filebin2 $HOME
RUN chown -R filebin2:filebin2 /var/log/filebin
USER filebin2
WORKDIR $HOME
ENTRYPOINT /usr/local/bin/filebin2
