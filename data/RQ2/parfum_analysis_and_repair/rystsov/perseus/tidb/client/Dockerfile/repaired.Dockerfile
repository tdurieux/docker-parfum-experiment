FROM ubuntu:17.10
LABEL maintainer="Denis Rystsov <rystsov.denis@gmail.com>"
RUN apt-get update -y
RUN apt-get install --no-install-recommends -y iputils-ping vim tmux less curl && rm -rf /var/lib/apt/lists/*;
RUN /bin/bash -c "curl -sL https://deb.nodesource.com/setup_8.x | bash -"
RUN apt-get install --no-install-recommends -y nodejs mysql-client && rm -rf /var/lib/apt/lists/*;
RUN mkdir -p /tidb
WORKDIR /tidb
COPY test.sh /tidb/test.sh
COPY schema.sql /tidb/schema.sql
COPY app /tidb/app
COPY lib /tidb/lib
WORKDIR /tidb/app
RUN npm install && npm cache clean --force;
WORKDIR /tidb
CMD ["/tidb/test.sh"]
