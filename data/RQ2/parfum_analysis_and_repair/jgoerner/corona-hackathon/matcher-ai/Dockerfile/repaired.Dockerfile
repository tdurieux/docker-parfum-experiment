FROM python:3.7-stretch

RUN apt-get update && apt-get install --no-install-recommends -yq build-essential libpq-dev python-dev && rm -rf /var/lib/apt/lists/*;

WORKDIR /matcher-ai

COPY requirements.txt /matcher-ai

RUN pip install --no-cache-dir --upgrade pip \
    && pip install --no-cache-dir -r requirements.txt

COPY . /matcher-ai

RUN pip install --no-cache-dir -r requirements.txt

EXPOSE 8000

ENTRYPOINT gunicorn -b 0.0.0.0:8000 'main:app'
