FROM debian:latest

LABEL authors="teuton.software@proton.me"

RUN apt-get update
RUN apt-get install -y apt-utils
RUN apt-get install -y vim tree
RUN apt-get install -y ruby
RUN gem install teuton
RUN mkdir /home/teuton

EXPOSE 80

WORKDIR /home/teuton
CMD ["/bin/bash"]
