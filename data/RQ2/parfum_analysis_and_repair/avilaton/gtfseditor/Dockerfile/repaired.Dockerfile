FROM ubuntu:wily
MAINTAINER Gastón Avila "avila.gas@gmail.com"

RUN apt-get update -y && apt-get install --no-install-recommends -y python-pip python-dev build-essential libpq-dev && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir pip --upgrade

RUN mkdir /srv/app
WORKDIR /srv/app
ADD ./requirements.txt /srv/app/requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# ADD . /srv/app

ENV PYTHONUNBUFFERED=1
EXPOSE 5000

CMD honcho start web
