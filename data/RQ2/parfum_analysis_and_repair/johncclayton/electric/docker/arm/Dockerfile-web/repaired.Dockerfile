FROM johncclayton/electric-pi-python:latest

LABEL maintainer="Neil Clayton, John Clayton" version="1.0"

VOLUME /www
WORKDIR /www

ENV ELECTRIC_WORKER=tcp://127.0.0.1:5001

EXPOSE 5000

CMD [ "./run_gunicorn.sh" ]