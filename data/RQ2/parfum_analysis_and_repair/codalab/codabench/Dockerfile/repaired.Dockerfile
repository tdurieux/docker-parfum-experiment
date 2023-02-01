FROM python:3.8

RUN apt-get update && apt-get install --no-install-recommends -yy gcc build-essential python-setuptools && rm -rf /var/lib/apt/lists/*;

ENV PYTHONUNBUFFERED 1

ADD requirements.dev.txt .
ADD requirements.txt .
RUN pip install --no-cache-dir -U pip
RUN pip install --no-cache-dir -r requirements.dev.txt

# INSTALL CHROMEDRIVER HERE?

WORKDIR /app
