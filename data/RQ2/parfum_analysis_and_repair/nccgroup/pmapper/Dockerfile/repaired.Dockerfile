FROM python:3.8-slim-buster

COPY . /app
RUN apt-get update ; apt-get install --no-install-recommends -y graphviz && rm -rf /var/lib/apt/lists/*;
RUN mkdir -p /storage
RUN pip install --no-cache-dir /app
ENV PMAPPER_STORAGE /storage

CMD sh
