# pull official base image
FROM python:3.8.11-slim-buster

# create directory for the app user
RUN mkdir -p /home/app

# create the app user
RUN addgroup --system app && adduser --system --group app

# create the appropriate directories
ENV HOME=/home/app
ENV APP_HOME=/home/app/code
RUN mkdir $APP_HOME
WORKDIR $APP_HOME

# set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1
ENV ENVIRONMENT prod


# install system dependencies
RUN apt-get update \
  && apt-get -y --no-install-recommends install netcat gcc libpq-dev \
  && apt-get clean && rm -rf /var/lib/apt/lists/*;

# install python dependencies
RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir -U setuptools
COPY ./requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# add app
COPY . .

# chown all the files to the app user
RUN chown -R app:app $APP_HOME

# change to the app user
USER app

# run gunicorn
CMD gunicorn --bind 0.0.0.0:5000 main:app -k uvicorn.workers.UvicornWorker