FROM python:3.9.2-slim-buster AS base

ARG APP_DIR=/usr/app/

USER root

RUN mkdir ${APP_DIR}

WORKDIR ${APP_DIR}

# graphviz is required by prefect[viz]==0.14.12
RUN apt-get update \
    && apt-get install --no-install-recommends -y build-essential graphviz \
    && apt-get clean && rm -rf /var/lib/apt/lists/*;

# pip requirements
COPY requirements.txt ${APP_DIR}

RUN pip install --no-cache-dir --upgrade pip \
    && pip3 install --no-cache-dir -r requirements.txt

CMD ["python3", "src/main.py"]