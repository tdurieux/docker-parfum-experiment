FROM debian:latest

LABEL authors="teuton.software@proton.me"

RUN apt-get update
RUN apt-get install --no-install-recommends -y apt-utils && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y vim tree && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y ruby && rm -rf /var/lib/apt/lists/*;
RUN gem install teuton
RUN mkdir /home/teuton

EXPOSE 80

WORKDIR /home/teuton
CMD ["/bin/bash"]
