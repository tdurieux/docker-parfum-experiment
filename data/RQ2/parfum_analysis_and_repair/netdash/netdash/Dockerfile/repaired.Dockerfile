FROM python:3.7-slim

ENV PYTHONUNBUFFERED=1
ENV PIP_DISABLE_PIP_VERSION_CHECK=1

# Add git to allow pip install packages from repositories
RUN apt-get -y update && apt-get -y --no-install-recommends install git && rm -rf /var/lib/apt/lists/*;

EXPOSE 8000

RUN apt-get install --no-install-recommends -y xmlsec1 libffi-dev libssl-dev && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir psycopg2-binary gunicorn djangosaml2~=0.17.2

RUN mkdir /usr/src/app && rm -rf /usr/src/app

COPY . /usr/src/app

WORKDIR /usr/src/app

RUN pip install --no-cache-dir -r requirements.txt && pip install --no-cache-dir -r requirements.user.txt

WORKDIR /usr/src/app/netdash

# Work around for permission issue on OpenShift
RUN chmod -R g+rw /usr/src/app

ENTRYPOINT ["/usr/src/app/docker-entrypoint.sh"]

CMD ["gunicorn", "--bind=0.0.0.0:8000", "--workers=2", "--threads=4", "--access-logfile=-", "--log-file=-", "netdash.wsgi"]
