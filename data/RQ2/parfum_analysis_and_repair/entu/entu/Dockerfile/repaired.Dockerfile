FROM python:2.7-slim-jessie

CMD ["python", "/usr/src/entu/app/main.py"]

WORKDIR /usr/src/entu

RUN apt-get update && apt-get install --no-install-recommends -y build-essential gcc python-imaging libjpeg-dev zlib1g-dev libpng12-dev libmysqlclient-dev && rm -rf /var/lib/apt/lists/*;

COPY ./ /usr/src/entu

RUN pip install --no-cache-dir -r requirements.txt
