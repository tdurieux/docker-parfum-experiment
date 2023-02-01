FROM python:3

WORKDIR /usr/src/user_app
ENV C_FORCE_ROOT 1

RUN pip install --no-cache-dir celery[redis] ipython
