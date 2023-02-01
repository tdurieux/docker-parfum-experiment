FROM ubuntu:trusty

RUN apt-get update && apt-get install --no-install-recommends -yq curl && apt-get clean && rm -rf /var/lib/apt/lists/*;

WORKDIR /app

COPY ./scripts/test.sh ./scripts/wait-for-parse.sh /app/

CMD ["./wait-for-parse.sh", "db", "./test.sh"]
