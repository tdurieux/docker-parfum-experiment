FROM python:3.6.2-alpine3.6

COPY . /opt/app
WORKDIR /opt/app

RUN pip install --no-cache-dir -r requirements.txt -r

CMD ["nosetests", "-s"]
