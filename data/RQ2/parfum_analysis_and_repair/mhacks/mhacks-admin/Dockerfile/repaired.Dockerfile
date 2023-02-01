FROM python:2.7

MAINTAINER Antonio Mika <me@antoniomika.me>

ADD . /MHacks-Website
WORKDIR /MHacks-Website

RUN pip install --no-cache-dir pillow
RUN pip install --no-cache-dir -r requirements.txt

RUN useradd -ms /bin/bash mhacks
USER mhacks

ENTRYPOINT ["python", "manage.py"]

EXPOSE 8000