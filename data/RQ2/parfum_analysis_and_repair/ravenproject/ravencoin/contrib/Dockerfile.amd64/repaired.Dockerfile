FROM amd64/ubuntu:latest

MAINTAINER cade <cade.call@mediciventures.com>

EXPOSE $RPCPORT

EXPOSE $PORT

RUN apt-get update && apt-get install --no-install-recommends -y bash net-tools && apt-get clean && rm -rf /var/lib/apt/lists/*;

RUN useradd -ms /bin/bash raven

RUN mkdir /etc/raven

RUN mkdir /var/lib/raven

RUN chown raven:raven /etc/raven /var/lib/raven

WORKDIR /home/raven

COPY --chown=raven:raven linux64/* /home/raven/

COPY --chown=raven:raven run.sh /home/raven/

USER raven

CMD ["/home/raven/run.sh"]
