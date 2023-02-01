FROM python:3.8
ENV PYTHONUNBUFFERED 1
RUN apt-get update && apt-get install --no-install-recommends -y swig libssl-dev dpkg-dev netcat gfortran libopenblas-dev liblapack-dev unzip && rm -rf /var/lib/apt/lists/*;

RUN wget -O /tmp/smtp2http.zip https://github.com/alash3al/smtp2http/releases/download/v3.0.0/smtp2http_linux_amd64.zip
RUN unzip /tmp/smtp2http.zip -d /tmp/
RUN mv /tmp/smtp2http_linux_amd64 /usr/local/bin/smtp2http
RUN chmod +x /usr/local/bin/smtp2http

RUN pip install --no-cache-dir -U pip poetry
ADD poetry.lock /code/
ADD pyproject.toml /code/
RUN poetry config virtualenvs.create false
WORKDIR /code
RUN /bin/bash -c '[[ -z "${IN_DOCKER}" ]] && poetry install --no-interaction --no-root || poetry install --no-dev --no-interaction --no-root'

ADD misc/dokku/CHECKS /app/
ADD misc/dokku/* /code/

COPY . /code/
RUN /code/manage.py collectstatic --noinput
