FROM python:3.6-slim-buster

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install --no-install-recommends -y gcc git && rm -rf /var/lib/apt/lists/*;

COPY requirements.txt /opt/app/requirements.txt
WORKDIR /opt/app
RUN pip3 install --no-cache-dir -r requirements.txt
COPY . /opt/app

ENV PYTHONUNBUFFERED=TRUE

ENTRYPOINT ["python3"]
