FROM python:3.7.3
WORKDIR /usr/local/app
RUN apt-get update && apt-get install --no-install-recommends -y groff-base && rm -rf /var/lib/apt/lists/*;
ADD Pipfile /usr/local/app
RUN pip install --no-cache-dir pipenv==2018.11.26 && pipenv install --skip-lock -d
ENTRYPOINT ["pipenv", "run"]
