FROM python:3.10-buster

ENV PYTHONUNBUFFERED=1

WORKDIR /code
COPY . /code/

RUN apt-get install -y --no-install-recommends openssl \
 && pip install --no-cache-dir --upgrade pip \
 && pip install --no-cache-dir -r requirements.txt \
 && rm -rf ~/.cache && rm -rf /var/lib/apt/lists/*;

CMD ["python", "-m", "monitoringdaemon"]
