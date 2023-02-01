# For more information, please refer to https://aka.ms/vscode-docker-python
FROM python:3.7-slim-buster

EXPOSE 8000

# Keeps Python from generating .pyc files in the container
ENV PYTHONDONTWRITEBYTECODE=1

# Turns off buffering for easier container logging
ENV PYTHONUNBUFFERED=1

# Install git for pip dependencies from repositories
RUN apt-get -y update && apt-get -y --no-install-recommends install git && rm -rf /var/lib/apt/lists/*;

# Install pip requirements
COPY Pipfile .
COPY Pipfile.lock .
RUN python -m pip install pipenv

WORKDIR /app
COPY . /app

RUN pipenv install --dev --system
