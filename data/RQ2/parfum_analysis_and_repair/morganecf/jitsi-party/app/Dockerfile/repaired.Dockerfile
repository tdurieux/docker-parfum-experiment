FROM python:3.7.7-stretch


RUN apt-get update && apt-get install --no-install-recommends -y libpq-dev && rm -rf /var/lib/apt/lists/*;

ADD requirements /requirements
RUN pip install --no-cache-dir --upgrade pip && pip install --no-cache-dir -r /requirements/prod.txt

ADD . /app
WORKDIR /app

CMD ["./start.sh"]
