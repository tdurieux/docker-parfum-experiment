FROM python:3.9
ENV PYTHONUNBUFFERED 1

RUN mkdir /webapps
WORKDIR /webapps

# Installing OS Dependencies
RUN apt-get update && apt-get upgrade -y && apt-get install --no-install-recommends -y \
  "postgresql-client=11+200+deb10u4" && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir -U pip setuptools

COPY requirements.txt /webapps/

RUN pip install --no-cache-dir -r /webapps/requirements.txt

ADD . /webapps/

# Django service
EXPOSE 8000
