FROM python:3.7

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

SHELL ["/bin/bash", "-c"]

RUN mkdir /code
WORKDIR /code

ADD requirements.txt /code/
ADD . /code/

RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir -r requirements.txt

RUN source /code/WikiContrib/.env

ENTRYPOINT ["/code/entrypoint.sh"]