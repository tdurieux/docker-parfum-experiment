FROM python:3.6
ENV PYTHONUNBUFFERED 1
WORKDIR /sapl-dev
COPY ./requirements ./requirements/
RUN apt update && \
    apt -y --no-install-recommends install graphviz-dev && \
    pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r ./requirements/dev-requirements.txt && rm -rf /var/lib/apt/lists/*;
EXPOSE 8000
