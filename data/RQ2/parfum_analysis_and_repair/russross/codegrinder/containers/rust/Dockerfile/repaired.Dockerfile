FROM arm64v8/debian:bullseye
MAINTAINER russ@russross.com

RUN apt update && apt upgrade -y

RUN apt install -y --no-install-recommends \
    make \
    python3 && rm -rf /var/lib/apt/lists/*;
RUN apt install -y --no-install-recommends \
    cargo && rm -rf /var/lib/apt/lists/*;

ADD https://cit.dixie.edu/cs/3520/cargo2junit /usr/local/bin/
RUN chmod 755 /usr/local/bin/cargo2junit

RUN mkdir /home/student && chmod 777 /home/student
USER 2000
WORKDIR /home/student
