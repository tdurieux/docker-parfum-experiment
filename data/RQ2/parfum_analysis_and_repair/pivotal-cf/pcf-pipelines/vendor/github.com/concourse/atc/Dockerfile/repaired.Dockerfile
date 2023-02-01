FROM ubuntu:17.10

# The Basics
RUN apt-get update && apt-get -y --no-install-recommends install curl && rm -rf /var/lib/apt/lists/*;

# install PhantomJS 2.1.1
RUN apt-get update && apt-get -y --no-install-recommends install libfontconfig bzip2 && rm -rf /var/lib/apt/lists/*;
RUN curl -f -L https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-2.1.1-linux-x86_64.tar.bz2 | tar -C /tmp -jxf - && \
      mv /tmp/phantomjs-*/bin/phantomjs /usr/local/bin && \
      rm -rf /tmp/phantomjs-*

# Go, with build-essential for gcc
RUN apt-get update && apt-get -y --no-install-recommends install build-essential && rm -rf /var/lib/apt/lists/*;
ADD go*.tar.gz /usr/local
ENV PATH $PATH:/usr/local/go/bin

# Git for `go get` in pull request task
RUN apt-get update && apt-get -y --no-install-recommends install git && rm -rf /var/lib/apt/lists/*;

# PostgreSQL
RUN apt-get update && apt-get -y --no-install-recommends install postgresql-9.6 && rm -rf /var/lib/apt/lists/*;
ENV PATH $PATH:/usr/lib/postgresql/9.6/bin
