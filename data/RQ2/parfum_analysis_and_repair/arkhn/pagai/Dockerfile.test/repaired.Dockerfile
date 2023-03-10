FROM arkhn/python-db-drivers:0.1.0

WORKDIR /app

COPY requirements/requirements-base.txt  /app/requirements-base.txt
COPY requirements/requirements-all.txt  /app/requirements.txt
RUN pip install --no-cache-dir -r requirements.txt --src /usr/local/src

COPY requirements/requirements-dev.txt /app
RUN pip install --no-cache-dir -r requirements-dev.txt
