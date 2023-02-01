FROM python:3.9-slim

RUN pip install --no-cache-dir pipenv
RUN apt update && apt install --no-install-recommends build-essential -y && rm -rf /var/lib/apt/lists/*;

RUN useradd -m app
USER app

WORKDIR /app
COPY . /app

RUN pipenv install --system
ENTRYPOINT ["python3", "main.py"]
