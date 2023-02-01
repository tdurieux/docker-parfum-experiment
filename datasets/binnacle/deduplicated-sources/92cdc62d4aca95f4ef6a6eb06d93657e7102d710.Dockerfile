FROM python:3.5.2

ENV APPLICATION_ROOT /app/

RUN pip install Django==1.10.2 \
  requests==2.11.1 \
  uWSGI==2.0.14


WORKDIR $APPLICATION_ROOT
ADD . $APPLICATION_ROOT

EXPOSE 8000

ENTRYPOINT ["uwsgi", "--ini", "uwsgi.ini"]
