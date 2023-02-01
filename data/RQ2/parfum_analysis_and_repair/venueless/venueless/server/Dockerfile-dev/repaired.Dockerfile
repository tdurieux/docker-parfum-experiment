FROM python:3.8

COPY requirements.txt /requirements.txt
RUN apt update && apt install --no-install-recommends -y poppler-utils && apt-get clean && rm -rf /var/lib/apt/lists/*
RUN pip3 install --no-cache-dir -U pip wheel setuptools && pip3 install --no-cache-dir -Ur requirements.txt
ENV VENUELESS_COMMIT_SHA=devcontainer
WORKDIR /app
EXPOSE 8375

