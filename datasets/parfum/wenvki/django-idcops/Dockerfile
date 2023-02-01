FROM python:3.7.7-alpine

# set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

RUN mkdir /opt/django-idcops
WORKDIR /opt/django-idcops
COPY . /opt/django-idcops

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories
RUN apk add jpeg-dev zlib-dev freetype-dev lcms2-dev openjpeg-dev \
    tiff-dev tk-dev tcl-dev harfbuzz-dev fribidi-dev jpeg g++

RUN pip install -U pip setuptools wheel -i https://mirrors.aliyun.com/pypi/simple/ || \
    pip install -U pip setuptools wheel
    
RUN pip install -i https://mirrors.aliyun.com/pypi/simple/ -r /opt/django-idcops/requirements.txt || \
    pip install -r /opt/django-idcops/requirements.txt

COPY ./idcops_proj/settings_for_docker.py  ./idcops_proj/settings.py

RUN ["rm", "-fr", "/opt/django-idcops/db.sqlite3"]

RUN ["chmod", "+x", "./config/entrypoint.sh"]

# run entrypoint.sh
ENTRYPOINT ["./config/entrypoint.sh"]