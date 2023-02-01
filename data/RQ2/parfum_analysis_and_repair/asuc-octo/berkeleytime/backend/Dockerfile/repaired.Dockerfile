FROM python:3.8-slim
RUN mkdir /backend
WORKDIR /backend
COPY . .
RUN apt-get update || : && apt-get install --no-install-recommends libpq-dev gcc -y && \
    python3 -m pip install -r requirements.txt && rm -rf /var/lib/apt/lists/*;
