FROM python:3.10.1-slim-buster
ENV PYTHONUNBUFFERED 1

ARG user=tdpuser
ARG group=tdpuser
ARG uid=1000
ARG gid=1000
ENV DJANGO_SETTINGS_MODULE=tdpservice.settings.local
ENV DJANGO_CONFIGURATION=Local
# Allows docker to cache installed dependencies between builds
COPY Pipfile Pipfile.lock /tdpapp/
WORKDIR /tdpapp/
# Download latest listing of available packages:
RUN apt-get -y update
# Upgrade already installed packages:
RUN apt-get -y upgrade
# Install a new package:
RUN apt-get install --no-install-recommends -y gcc && apt-get install --no-install-recommends -y graphviz && apt-get install --no-install-recommends -y graphviz-dev && rm -rf /var/lib/apt/lists/*;
# Install pipenv
RUN pip install --no-cache-dir --upgrade pip pipenv && pipenv install --dev --system --deploy

# Adds our application code to the image
COPY . /tdpapp
WORKDIR /tdpapp/

RUN groupadd -g ${gid} ${group} && useradd -u ${uid} -g ${group} -s /bin/sh ${user}

RUN chown -R tdpuser /tdpapp && chmod u+x gunicorn_start.sh wait_for_services.sh


CMD ["./gunicorn_start.sh"]
