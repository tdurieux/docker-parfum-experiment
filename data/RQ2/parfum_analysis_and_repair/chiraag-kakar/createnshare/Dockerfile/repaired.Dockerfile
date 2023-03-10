# pull official base image
FROM python:3.9.6-alpine

# set work directory
WORKDIR /usr/src/app

# set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# install psycopg2 dependencies
RUN apk update \
    && apk add --no-cache postgresql-dev gcc python3-dev musl-dev

# install dependencies
RUN pip install --no-cache-dir --upgrade pip
COPY ./requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# copy project
COPY . .
RUN python manage.py makemigrations app
RUN python manage.py migrate app
RUN python manage.py collectstatic --noinput --clear
# EXPOSE 8000
# Run application
CMD gunicorn django_heroku.wsgi:application