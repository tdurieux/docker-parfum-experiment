FROM ubuntu:trusty

RUN apt-get update && apt-get install -yq curl && apt-get clean

WORKDIR /app

COPY ./scripts/test.sh ./scripts/wait-for-parse.sh /app/

CMD ["./wait-for-parse.sh", "db", "./test.sh"]
