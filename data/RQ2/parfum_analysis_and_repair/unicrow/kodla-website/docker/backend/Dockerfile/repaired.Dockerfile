FROM python:3.6
RUN apt-get update && apt-get install --no-install-recommends -y gettext && rm -rf /var/lib/apt/lists/*;
ENV PYTHONUNBUFFERED 1

## Add the wait script to the image
ADD https://github.com/ufoscout/docker-compose-wait/releases/download/2.5.0/wait /wait
RUN chmod +x /wait

## Source code
RUN mkdir /code
WORKDIR /code
ADD requirements/ /code/requirements/
RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir -r requirements/staging.txt
RUN pip install --no-cache-dir -r requirements/extra.txt
ADD . /code/
