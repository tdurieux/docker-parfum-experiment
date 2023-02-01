FROM openjdk:11

WORKDIR /usr/app/

RUN apt-get update && \
  apt-get upgrade -y && \
  apt-get install --no-install-recommends -y build-essential && rm -rf /var/lib/apt/lists/*;

COPY . .

RUN make install

EXPOSE 8080

CMD ["make", "serve"]
