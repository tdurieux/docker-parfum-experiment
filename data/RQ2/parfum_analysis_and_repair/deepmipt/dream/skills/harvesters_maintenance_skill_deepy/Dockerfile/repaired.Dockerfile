FROM python:3.7.4

RUN mkdir /src

COPY ./requirements.txt /src/requirements.txt
RUN pip install --no-cache-dir -r /src/requirements.txt

COPY . /src/
WORKDIR /src

CMD gunicorn --workers=1 --bind 0.0.0.0:3002 server:app
