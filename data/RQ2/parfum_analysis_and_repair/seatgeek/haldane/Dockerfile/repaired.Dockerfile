FROM python:2-onbuild

RUN pip install --no-cache-dir greenlet gevent gunicorn honcho

RUN pip install --no-cache-dir ./

CMD [ "honcho", "start" ]
