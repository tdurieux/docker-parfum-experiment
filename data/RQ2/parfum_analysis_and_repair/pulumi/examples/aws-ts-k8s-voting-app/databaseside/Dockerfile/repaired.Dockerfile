FROM ubuntu:18.04

WORKDIR /

EXPOSE 5432

RUN apt update && \
    apt install --no-install-recommends -y postgresql && rm -rf /var/lib/apt/lists/*;

ADD database /database

CMD [ "/database/startDatabase.sh" ]
