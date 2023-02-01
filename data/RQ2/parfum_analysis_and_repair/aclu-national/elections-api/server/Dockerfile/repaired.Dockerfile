# pull official base image
FROM python:2.7

# set work directory
WORKDIR /usr/local/aclu/elections-api

# set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# install dependencies
RUN apt update \
    # psycopg2 dependencies \
    && apt -y --no-install-recommends install libghc-hdbc-postgresql-dev gcc python2-dev musl-dev make curl postgis \
      fail2ban ufw htop emacs24-nox \
      build-essential gdal-bin unzip nodejs npm \

      jq \

      libopencv-dev && rm -rf /var/lib/apt/lists/*;

# install python dependencies
RUN pip install --no-cache-dir --upgrade pip
COPY ./requirements.txt /usr/local/aclu/elections-api/requirements.txt
COPY ./dev-requirements.txt /usr/local/aclu/elections-api/dev-requirements.txt
RUN pip install --no-cache-dir -r requirements.txt -r

# install node dependencies
RUN npm install -g mapshaper opencv --unsafe-perm=true smartcrop-cli --unsafe-perm=true && npm cache clean --force;