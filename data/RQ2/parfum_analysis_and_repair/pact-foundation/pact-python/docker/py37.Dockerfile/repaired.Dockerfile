FROM python:3.7.9-alpine3.11

WORKDIR /home

COPY requirements_dev.txt .

RUN apk update
RUN apk upgrade

RUN apk add --no-cache gcc py-pip python-dev libffi-dev openssl-dev gcc libc-dev bash make

RUN python -m pip install psutil
RUN pip install --no-cache-dir -r requirements_dev.txt

CMD tox -e py37
