FROM python:3.7.6-slim-buster as base

# required to install packages from github
RUN apt-get -y update
RUN apt-get -y --no-install-recommends install git && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir --upgrade pip

WORKDIR /app

COPY requirements.txt requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

COPY ./skill_manager skill_manager

COPY logging.conf logging.conf

FROM base as test
RUN apt -y --no-install-recommends install docker.io && rm -rf /var/lib/apt/lists/*;

COPY requirements.dev.txt requirements.dev.txt
RUN pip install --no-cache-dir -r requirements.dev.txt

COPY tests tests
COPY pytest.ini pytest.ini

FROM base as build
EXPOSE 8000

CMD ["uvicorn", "skill_manager.main:app", "--host", "0.0.0.0", "--port", "8000", "--log-config", "logging.conf"]
