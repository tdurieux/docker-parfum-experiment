FROM python:3.7.3
WORKDIR /usr/local/app
RUN apt-get update && apt-get install -y groff-base
ADD Pipfile /usr/local/app
RUN pip install pipenv==2018.11.26 && pipenv install --skip-lock -d
ENTRYPOINT ["pipenv", "run"]
