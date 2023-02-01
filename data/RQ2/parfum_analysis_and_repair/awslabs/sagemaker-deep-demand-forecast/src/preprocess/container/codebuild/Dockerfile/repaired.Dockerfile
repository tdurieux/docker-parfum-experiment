ARG BASE_IMAGE
FROM ${BASE_IMAGE}

COPY requirements.txt /opt/app/requirements.txt
WORKDIR /opt/app
RUN pip3 install --no-cache-dir -r requirements.txt
COPY . /opt/app

ENV PYTHONUNBUFFERED=TRUE

ENTRYPOINT ["python3"]
