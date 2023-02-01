FROM quay.io/aptible/ubuntu
ADD . /app
WORKDIR /app

RUN apt-get update && apt-get install --no-install-recommends -y python python-dev python-distribute python-pip libpq-dev libffi-dev libjpeg-dev && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir Flask
RUN pip install --no-cache-dir -r ./requirements.txt

ENV PORT 3000
EXPOSE 3000