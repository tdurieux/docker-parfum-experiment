FROM python:3.6-onbuild

ENV PATH /usr/local/bin:$PATH

MAINTAINER SylvanasSun sylvanas.sun@gmail.com

RUN pip install --no-cache-dir -r requirements.txt

RUN python app.py