FROM python:3.7-stretch

RUN echo "US/Central" > /etc/timezone
RUN dpkg-reconfigure -f noninteractive tzdata

ENV PYTHONUNBUFFERED 1
ENV PYTHONPATH /app

RUN mkdir /app
WORKDIR /app

ADD Pipfile /app/
ADD Pipfile.lock /app/

RUN apt-get update -qq && apt-get install --no-install-recommends -y mysql-client netcat && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir -U pip setuptools
RUN pip install --no-cache-dir pipenv
RUN pipenv install --dev --deploy --ignore-pipfile

ADD wait-for-mysqld.sh /wait-for-mysqld.sh
ADD appstart.sh /appstart.sh
