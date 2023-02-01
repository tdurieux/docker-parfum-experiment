FROM python:3.6

ENV PYTHONUNBUFFERED 1

# Note that we want postgresql-client so 'manage.py dbshell' works.
# We want xmlsec1 to support SAML SSO
RUN apt-get update && apt-get install --no-install-recommends -y postgresql-client xmlsec1 && rm -rf /var/lib/apt/lists/*;

RUN mkdir /app
RUN mkdir /app/logs
RUN mkdir /var/log/talentmap/ && chmod a+wrxs /var/log/talentmap/
WORKDIR /app

COPY talentmap_api /app/talentmap_api/
ADD requirements.txt wait-for-postgres.sh manage.py setup.cfg /app/

RUN chmod +x wait-for-postgres.sh
RUN pip install --no-cache-dir -r requirements.txt
