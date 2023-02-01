FROM python:3.9-slim

RUN apt-get update && apt-get -y --no-install-recommends install git && rm -rf /var/lib/apt/lists/*;

RUN mkdir /app

RUN pip install --no-cache-dir pipenv

COPY . /app/

WORKDIR /app/

RUN pipenv install --system --deploy

ENTRYPOINT ["python3"]
CMD ["-m", "bot"]
