FROM python:3.7-slim-stretch

RUN pip install --no-cache-dir pipenv==2018.11.26 \
  && pip install --no-cache-dir awscli==1.11.174
RUN apt update && apt install --no-install-recommends -y libsnappy-dev build-essential libpq-dev \
  libcairo2 libpango-1.0-0 libpangocairo-1.0-0 libgdk-pixbuf2.0-0 libffi-dev shared-mime-info && rm -rf /var/lib/apt/lists/*;

RUN mkdir -p /usr/src/app && rm -rf /usr/src/app
WORKDIR /usr/src/app

ENV AWS_DEFAULT_REGION eu-west-1

COPY Pipfile Pipfile
COPY Pipfile.lock Pipfile.lock

RUN pipenv install --deploy --system

EXPOSE 5000

ENTRYPOINT ["sh", "docker-entrypoint.sh"]

COPY . /usr/src/app
