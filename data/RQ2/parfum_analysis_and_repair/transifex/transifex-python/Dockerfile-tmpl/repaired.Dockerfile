ARG PYTHON_VERSION
ARG DJANGO_VERSION

FROM python:${PYTHON_VERSION} AS builder

RUN mkdir -p /usr/app
WORKDIR /usr/app

##########################
#### tests image ###
ARG PYTHON_VERSION
ARG DJANGO_VERSION

RUN if [ ${PYTHON_VERSION} > 3 ]; then \
    alias python=python3 \
    ;fi


FROM builder as native
ARG DJANGO_VERSION

COPY ./ /usr/app

RUN pip install --no-cache-dir -r ./requirements/test.txt
RUN pip install --no-cache-dir Django==${DJANGO_VERSION}
RUN pip install --no-cache-dir pytest-django >-3.0

ENV PYTHONDONTWRITEBYTECODE=1
ENV DJANGO_SETTINGS_MODULE=tests.native.django.settings
ENV PYTHONPATH=$PYTHONPATH:$(pwd)

CMD ["/bin/sh"]
