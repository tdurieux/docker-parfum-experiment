FROM python:3

COPY ./app/. /usr/src/app/

WORKDIR /usr/src/app

RUN pip install --no-cache-dir flask
RUN pip install --no-cache-dir requests

EXPOSE 5000
CMD [ "python", "./main.py" ]