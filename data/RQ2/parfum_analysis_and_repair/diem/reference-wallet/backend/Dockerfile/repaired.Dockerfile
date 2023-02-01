FROM python:3.7-slim

WORKDIR /wallet

RUN apt-get update && apt-get install --no-install-recommends -y gcc git && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y curl netcat && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir pipenv

COPY wait.sh /
COPY backend/ .

RUN pipenv install --deploy --system
