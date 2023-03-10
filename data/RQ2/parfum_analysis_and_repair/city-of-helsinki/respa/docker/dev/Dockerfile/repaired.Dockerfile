FROM python:3.6

WORKDIR /usr/src/app

ENV APP_NAME respa

RUN apt-get update && apt-get install --no-install-recommends -y gdal-bin postgresql-client && rm -rf /var/lib/apt/lists/*;

COPY requirements.txt ./requirements.txt
COPY dev-requirements.txt ./dev-requirements.txt

RUN pip install --no-cache-dir -r dev-requirements.txt

COPY . .

RUN echo 'alias rs="python manage.py runserver 0:8000"' >> ~/.bashrc
