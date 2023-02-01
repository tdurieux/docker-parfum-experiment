FROM python:3.9

RUN apt-get update && apt-get install --no-install-recommends -y python3-dev default-libmysqlclient-dev build-essential && rm -rf /var/lib/apt/lists/*;
COPY requirements.txt requirements.txt
RUN pip3 install --no-cache-dir -r requirements.txt

COPY jobs.py common.py ./

ENTRYPOINT ["celery", "-A", "jobs", "worker", "--loglevel=INFO"]
