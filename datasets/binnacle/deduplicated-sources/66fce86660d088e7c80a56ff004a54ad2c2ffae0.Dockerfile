FROM ubuntu:17.10
LABEL maintainer="Denis Rystsov <rystsov.denis@gmail.com>"
RUN apt-get update -y
RUN apt-get install -y wget iputils-ping vim tmux less curl
RUN /bin/bash -c "curl -sL https://deb.nodesource.com/setup_8.x | bash -"
RUN apt-get install -y nodejs
RUN mkdir -p /roach
WORKDIR /roach
RUN wget https://binaries.cockroachdb.com/cockroach-latest.linux-amd64.tgz
RUN tar xzvf cockroach-latest.linux-amd64.tgz
RUN rm cockroach-latest.linux-amd64.tgz
COPY test.sh /roach/test.sh
COPY schema.sql /roach/schema.sql
COPY app /roach/app
COPY lib /roach/lib
WORKDIR /roach/app
RUN npm install
WORKDIR /roach
CMD /roach/test.sh
