FROM ubuntu:12.04
ENV PYTHONUNBUFFERED 1

# Basics
RUN apt-get update -qq && apt-get install --no-install-recommends -y postgresql-client git-core libldap2-dev libsasl2-dev && rm -rf /var/lib/apt/lists/*;
# Libreoffice
RUN apt-get install --no-install-recommends -y libreoffice-base-core libreoffice-calc libreoffice-common libreoffice-core libreoffice-math libreoffice-writer python-uno && rm -rf /var/lib/apt/lists/*;
# Probably can remove this if we use the docker python image and py3
RUN apt-get install --no-install-recommends -y python-pip python-dev libpq-dev libjpeg-dev g++ && rm -rf /var/lib/apt/lists/*;
# Supervisor for libreoffice
RUN apt-get install --no-install-recommends -y supervisor && rm -rf /var/lib/apt/lists/*;

RUN mkdir -p /tmp/django-sis_libreoffice
ENV HOME /tmp/django-sis_libreoffice
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

RUN mkdir /code
WORKDIR /code
ADD core-requirements.txt /code/
RUN pip install --no-cache-dir -r core-requirements.txt
ADD dev-requirements.txt /code/
RUN pip install --no-cache-dir -r dev-requirements.txt
ADD requirements.txt /code/
RUN pip install --no-cache-dir -r requirements.txt
