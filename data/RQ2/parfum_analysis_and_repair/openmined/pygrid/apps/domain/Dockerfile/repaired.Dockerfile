FROM python:3.8

RUN mkdir /app
WORKDIR /app

RUN apt-get update && apt-get install --no-install-recommends -y git python-dev python3-dev && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir poetry
COPY poetry.lock pyproject.toml entrypoint.sh /app/
COPY /src /app/src

WORKDIR /app/
RUN poetry export -f requirements.txt --output requirements.txt --without-hashes
RUN pip3 install --no-cache-dir -r requirements.txt

ENTRYPOINT ["sh", "entrypoint.sh"]
