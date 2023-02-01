FROM ubuntu:18.04
RUN apt-get update -y && apt-get upgrade -y
RUN apt-get install --no-install-recommends git curl -y && rm -rf /var/lib/apt/lists/*;
#RUN apt install nodejs npm -y
RUN apt install --no-install-recommends curl -y && rm -rf /var/lib/apt/lists/*;
RUN curl -f -sL https://deb.nodesource.com/setup_8.x | bash -
RUN apt-get install --no-install-recommends -y build-essential nodejs && rm -rf /var/lib/apt/lists/*;
RUN mkdir /root/backend
COPY . /root/backend
RUN cd /root/backend && npm install && npm cache clean --force;
