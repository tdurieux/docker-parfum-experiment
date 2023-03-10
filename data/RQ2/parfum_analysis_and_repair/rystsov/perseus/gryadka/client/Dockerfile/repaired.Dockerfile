FROM ubuntu:17.10
LABEL maintainer="Denis Rystsov <rystsov.denis@gmail.com>"
RUN apt-get update -y
RUN apt-get install --no-install-recommends -y iputils-ping vim tmux less curl && rm -rf /var/lib/apt/lists/*;
RUN /bin/bash -c "curl -sL https://deb.nodesource.com/setup_8.x | bash -"
RUN apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;
RUN mkdir -p /gryadka
WORKDIR /gryadka
COPY test.sh /gryadka/test.sh
COPY app /gryadka/app
WORKDIR /gryadka/app
RUN npm install && npm cache clean --force;
WORKDIR /gryadka
CMD /gryadka/test.sh
