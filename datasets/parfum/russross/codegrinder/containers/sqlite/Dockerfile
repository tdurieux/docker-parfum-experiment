FROM arm64v8/debian:bullseye
MAINTAINER russ@russross.com

RUN apt update && apt upgrade -y

RUN apt install -y --no-install-recommends \
    make \
    python3
RUN apt install -y --no-install-recommends \
    sqlite3

RUN mkdir /home/student && chmod 777 /home/student
USER 2000
WORKDIR /home/student
