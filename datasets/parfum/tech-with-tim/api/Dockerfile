FROM python:3.8-slim

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONFAULTHANDLER 1

# Let service stop gracefully
STOPSIGNAL SIGQUIT

# Copy project files into working directory
WORKDIR /app

RUN apt-get update && apt-get install gcc -y

RUN pip install pipenv
COPY Pipfile Pipfile.lock ./
RUN pipenv install --deploy --system

ADD . /app

# Run the API.
CMD python launch.py runserver --initdb --verbose --debug
