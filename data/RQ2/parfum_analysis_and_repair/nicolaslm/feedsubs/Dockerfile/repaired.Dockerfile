FROM python:3.9-buster

ENTRYPOINT ["manage.py"]
ENV DJANGO_SETTINGS_MODULE=feedsubs.settings.prod

RUN mkdir /opt/code /opt/static

COPY requirements.txt /opt/code/
RUN pip install --no-cache-dir -U pip setuptools && pip install --no-cache-dir -r /opt/code/requirements.txt

COPY . /opt/code
RUN pip install --no-cache-dir /opt/code[prod]

# These secrets are only used to run collectstatic
RUN SECRET_KEY=x DB_PASSWORD=x EMAIL_HOST_PASSWORD=x SENTRY_DSN=https://9@xsfdf.rtd/2 AWS_ACCESS_KEY_ID=x AWS_SECRET_ACCESS_KEY=x manage.py collectstatic

USER nobody
