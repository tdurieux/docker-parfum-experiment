FROM ubuntu:20.04
USER root
RUN apt update
RUN apt install --no-install-recommends -y curl && rm -rf /var/lib/apt/lists/*;
RUN curl -f -s https://deb.nodesource.com/setup_16.x | bash -
RUN apt update
RUN apt install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;
RUN mkdir /gitlab-notify
WORKDIR /gitlab-notify
COPY . /gitlab-notify
RUN npm install && npm cache clean --force;
