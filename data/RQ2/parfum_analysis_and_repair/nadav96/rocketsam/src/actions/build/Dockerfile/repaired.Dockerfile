FROM ubuntu:latest
RUN echo '5' > /v.txt

RUN apt-get update --fix-missing && DEBIAN_FRONTEND="noninteractive" TZ="Europe/London" apt-get --no-install-recommends install -y python3-pip zip nodejs npm python3.7 && rm -rf /var/lib/apt/lists/*;
RUN echo 'alias md5="md5sum"' >> ~/.bashrc
RUN echo 'alias python3.7="python3"' >> ~/.bashrc