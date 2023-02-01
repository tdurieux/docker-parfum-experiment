FROM ubuntu:latest

RUN apt-get -y update
RUN apt-get -y upgrade
RUN apt-get install --no-install-recommends -y build-essential && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends git -y && rm -rf /var/lib/apt/lists/*;
RUN DEBIAN_FRONTEND="noninteractive" apt-get --no-install-recommends -y install tzdata && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends nginx -y && rm -rf /var/lib/apt/lists/*;
RUN git clone https://github.com/zgrossbart/jdd.git
RUN cp -r jdd/* /var/www/html/
CMD ["nginx", "-g", "daemon off;"]


