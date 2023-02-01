# Runs myapp under gunicorn.
# N.B. needs an external web server for the static files by sharing volume /var/www/html
FROM python:3

WORKDIR /usr/src/app

ENV DJANGO_DEBUG=false
ENV OAUTH2_SERVER=https://oauth-test.cc.columbia.edu
ENV RESOURCE_SERVER_ID=demo-django-jsonapi-training_validator
ENV RESOURCE_SERVER_SECRET=SaulGoodman

COPY requirements-django.txt .
COPY dist/*whl .
COPY myapp/fixtures/testcases.yaml .
COPY myapp/fixtures/adminuser.yaml .

# can manually login and create the superuser with:
# docker exec -it graviteeioapiplatform_demo_app_1 bash
# root@demoapp:/usr/src/app# django-admin createsuperuser --settings=training.settings
# or just pull one in with a fixture which is *not* in the git repo