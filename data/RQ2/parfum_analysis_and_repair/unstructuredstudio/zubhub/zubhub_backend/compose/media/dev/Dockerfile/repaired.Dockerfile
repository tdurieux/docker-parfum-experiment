FROM python:3.8-slim-buster

ENV PYTHONUNBUFFERED 1

# Python build stage

RUN apt-get update \
  # dependencies for building Python packages \
  && apt-get install --no-install-recommends -y build-essential procps netcat \
  # psycopg2 dependencies
  && apt-get install --no-install-recommends -y libpq-dev \
  # Translations dependencies
  && apt-get install --no-install-recommends -y gettext \
  # cleaning up unused files
  && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false \
  && rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install --no-install-recommends ffmpeg -y && rm -rf /var/lib/apt/lists/*;


WORKDIR /home

# copying neccessary files to work directory
COPY ./compose/media/requirements.txt /home/

RUN pip install --no-cache-dir --upgrade pip wheel \
  # Requirements are installed here to ensure they will be cached.
  && pip install --no-cache-dir -r /home/requirements.txt


# copy project
COPY ./media/ /home/media/


COPY ./compose/media/dev/start /home/start
RUN sed -i 's/\r$//g' /home/start
RUN chmod +x /home/start

COPY ./compose/docker_secrets_expand.sh /docker_secrets_expand.sh
RUN sed -i 's/\r$//g' /docker_secrets_expand.sh
RUN chmod +x /docker_secrets_expand.sh

ENTRYPOINT [ "/home/start" ]