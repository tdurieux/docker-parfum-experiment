FROM python:3.9-buster

RUN apt-get update && apt-get -qy install gettext postgresql-client unzip

COPY scripts/initdb.py /opt/hsreplay.net/initdb.py

RUN pip install --upgrade pip==21.3.1 wheel setuptools pipenv==2022.1.8

ENV PYTHONPATH=/opt/hsreplay.net/source \
	DJANGO_SETTINGS_MODULE=hsreplaynet.settings \
	HSREPLAYNET_DEBUG=1 \
	AWS_DEFAULT_REGION=us-east-1

CMD ["/opt/hsreplay.net/source/manage.py", "runserver", "0.0.0.0:8000"]
