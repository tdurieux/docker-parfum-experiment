FROM python:3.8-slim

ENV PYTHONUNBUFFERED 1

RUN groupadd user && useradd --create-home --home-dir /home/user -g user user
WORKDIR /home/user/app/backend

# Install system dependencies
RUN apt-get update && apt-get install --no-install-recommends gcc build-essential libpq-dev -y && \
    python3 -m pip install --no-cache-dir pip-tools && rm -rf /var/lib/apt/lists/*;

# install python dependencies
ADD *requirements.in /home/user/app/backend/
RUN pip-compile requirements.in > requirements.txt && \
    pip-compile dev-requirements.in > dev-requirements.txt

RUN pip install --no-cache-dir -r requirements.txt && \
    pip install --no-cache-dir -r dev-requirements.txt && \
    pip install --no-cache-dir psycopg2-binary

# Clean the house
RUN apt-get purge libpq-dev -y && apt-get autoremove -y && \
    rm /var/lib/apt/lists/* rm -rf /var/cache/apt/*

ADD backend/ /home/user/app/backend

USER user
CMD gunicorn {{project_name}}.wsgi --log-file - -b 0.0.0.0:8000 --reload
