# BUILD
# pull official base image
FROM python:3.8.3-alpine as build

# set work directory
WORKDIR /srv/app

# set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# install dependencies for build of pyscopg2 etc
RUN apk add --update --no-cache \
  gcc \
  libc-dev \
  linux-headers \
  postgresql-dev \
  musl-dev \
  zlib zlib-dev

# Copy project files
COPY . .

# install dependencies
RUN pip install --no-cache-dir --upgrade pip
COPY ./requirements.txt .
RUN pip wheel --no-cache-dir --no-deps \
  --wheel-dir /srv/app/wheels -r requirements.txt


# FINAL
# pull official base image
FROM python:3.8.3-alpine

# create the app user
RUN addgroup -S app && adduser -S app -G app

# create the appropriate directories
# ENV HOME=/srv
ENV APP_HOME=/srv/app
RUN mkdir $APP_HOME
RUN mkdir $APP_HOME/static
RUN mkdir $APP_HOME/media
WORKDIR $APP_HOME

# install dependencies
RUN apk add --update --no-cache libpq postgresql-client
COPY --from=build /srv/app/wheels /wheels
COPY --from=build /srv/app/requirements.txt .
RUN pip install --no-cache-dir --no-cache /wheels/*

# copy entrypoint-prod.sh
COPY ./entrypoint.prod.sh $APP_HOME

# copy project
COPY . $APP_HOME

# chown all the files to the app user
RUN chown -R app:app $APP_HOME

# change to the app user
USER app

# run entrypoint.prod.sh
ENTRYPOINT ["/srv/app/entrypoint.prod.sh"]