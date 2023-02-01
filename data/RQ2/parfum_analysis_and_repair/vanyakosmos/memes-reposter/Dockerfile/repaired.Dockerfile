FROM python:3.6

RUN apt-get -y update && apt-get -y --no-install-recommends install libav-tools && rm -rf /var/lib/apt/lists/*;

WORKDIR /app

RUN pip install --no-cache-dir pipenv
COPY ./Pipfile /app
COPY ./Pipfile.lock /app
RUN pipenv install --system --deploy
COPY . /app
# setup required env vars in .env file (SECRET_KEY, tg token...)
RUN python manage.py collectstatic --noinput -v 0
