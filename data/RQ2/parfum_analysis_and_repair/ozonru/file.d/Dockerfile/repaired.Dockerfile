FROM ubuntu:20.04

RUN apt-get update && apt-get install --no-install-recommends systemd -y && rm -rf /var/lib/apt/lists/*;

WORKDIR /file.d

COPY ./file.d .

CMD [ "./file.d" ]
