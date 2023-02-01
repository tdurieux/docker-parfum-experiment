FROM python:3.9

COPY ./aio-proxy /app

WORKDIR /app

RUN pip install --no-cache-dir -r requirements.pip

EXPOSE 4400

CMD [ "make", "run" ]
