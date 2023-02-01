FROM registry.access.redhat.com/ubi8/python-36
MAINTAINER Jake Moshenko jmoshenk@redhat.com

COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

COPY migration.py .

ENTRYPOINT ["python", "migration.py"]
