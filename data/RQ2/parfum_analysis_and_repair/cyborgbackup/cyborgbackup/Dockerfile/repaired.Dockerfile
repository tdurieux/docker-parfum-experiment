FROM python:3.8

ENV PYTHONUNBUFFERED 1
ENV DJANGO_ENV dev
ENV DOCKER_CONTAINER 1

COPY ./requirements.txt /cyborgbackup/requirements.txt
RUN pip install --no-cache-dir -r /cyborgbackup/requirements.txt
RUN apt-get update && apt-get install --no-install-recommends -y borgbackup && rm -rf /var/lib/apt/lists/*;

COPY ./src/ /cyborgbackup/

RUN mkdir -p /cyborgbackup/var/run

WORKDIR /cyborgbackup/

EXPOSE 8000
