FROM ubuntu:20.04

RUN apt update && \
    apt install --no-install-recommends -y software-properties-common && \
    add-apt-repository ppa:cartavis-team/carta-testing && \
    apt update && \
    apt install --no-install-recommends -y carta-beta && rm -rf /var/lib/apt/lists/*;

RUN mkdir /carta
WORKDIR /carta
ENV HOME /carta

# nsswitch for correct sss lookup
ADD src/nsswitch.conf /etc/
ADD src/skaha-carta /carta/

EXPOSE 6901
RUN chmod -R a+rwx /carta

CMD ["/carta/skaha-carta"]
# CMD ["carta", " --no_browser"]