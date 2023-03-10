FROM arm32v7/ubuntu:latest

MAINTAINER cade <cade.call@mediciventures.com>

EXPOSE $RPCPORT

EXPOSE $PORT

RUN useradd -ms /bin/bash raven

RUN mkdir /etc/raven

RUN mkdir /var/lib/raven

RUN chown raven:raven /etc/raven /var/lib/raven

WORKDIR /home/raven

COPY --chown=raven:raven linux64/* ./run.sh /home/raven/

USER raven

CMD ["/home/raven/run.sh"]