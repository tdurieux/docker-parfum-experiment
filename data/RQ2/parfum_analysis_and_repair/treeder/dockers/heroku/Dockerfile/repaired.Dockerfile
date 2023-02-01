FROM ubuntu:15.04

ADD install-ubuntu.sh /home/
RUN chmod +x /home/install-ubuntu.sh

RUN apt-get install --no-install-recommends -y \
   wget \
   git && rm -rf /var/lib/apt/lists/*;

RUN /home/install-ubuntu.sh

ENTRYPOINT ["heroku"]
