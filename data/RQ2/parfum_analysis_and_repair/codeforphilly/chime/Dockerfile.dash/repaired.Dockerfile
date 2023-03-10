FROM python:3.7.7-slim-buster

WORKDIR /code

ARG PORT
ENV PORT $PORT
ENV PARAMETERS=./defaults/webapp.cfg

COPY README.md .
COPY setup.py .
COPY setup.cfg .
COPY src src
COPY defaults ./src/defaults
RUN pip install --no-cache-dir -q .

# EXPOSE $PORT

CMD gunicorn dash_app:server --bind 0.0.0.0:$PORT --chdir src/
