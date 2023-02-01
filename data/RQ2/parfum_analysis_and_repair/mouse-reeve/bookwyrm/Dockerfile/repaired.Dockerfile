FROM python:3.9

ENV PYTHONUNBUFFERED 1

RUN mkdir /app /app/static /app/images

WORKDIR /app

RUN apt-get update && apt-get install --no-install-recommends -y gettext libgettextpo-dev tidy && apt-get clean && rm -rf /var/lib/apt/lists/*;

COPY requirements.txt /app/
RUN pip install -r requirements.txt --no-cache-dir
