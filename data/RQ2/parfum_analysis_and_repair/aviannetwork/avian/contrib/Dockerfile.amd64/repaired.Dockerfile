FROM amd64/ubuntu:latest

MAINTAINER cade <cade.call@mediciventures.com>

EXPOSE $RPCPORT

EXPOSE $PORT

RUN apt-get update && apt-get install --no-install-recommends -y bash net-tools && apt-get clean && rm -rf /var/lib/apt/lists/*;

RUN useradd -ms /bin/bash avian

RUN mkdir /etc/avian

RUN mkdir /var/lib/avian

RUN chown avian:avian /etc/avian /var/lib/avian

WORKDIR /home/avian

COPY --chown=avian:avian linux64/* /home/avian/

COPY --chown=avian:avian run.sh /home/avian/

USER avian

CMD ["/home/avian/run.sh"]
