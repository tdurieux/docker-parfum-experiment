FROM johncclayton/electric-pi-python:latest

LABEL maintainer="Neil Clayton, John Clayton" version="1.0"

VOLUME /www
VOLUME /opt/prefs

WORKDIR /www

ENV ELECTRIC_WORKER_LISTEN=tcp://0.0.0.0:5001

EXPOSE 5001

CMD [ "./run_zmq_worker.sh" ]