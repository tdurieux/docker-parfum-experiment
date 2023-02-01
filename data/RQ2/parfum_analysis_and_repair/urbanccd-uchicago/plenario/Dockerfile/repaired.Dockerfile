FROM python:3.6

WORKDIR /app

RUN apt-get update -qq && \
    apt-get install --no-install-recommends -qq -y build-essential libpq-dev git-core gdal-bin libgeos-dev postgresql-client && \
    pip install --no-cache-dir -U pip && rm -rf /var/lib/apt/lists/*;

COPY requirements.txt /app/
RUN pip install --no-cache-dir -r /app/requirements.txt

COPY . /app