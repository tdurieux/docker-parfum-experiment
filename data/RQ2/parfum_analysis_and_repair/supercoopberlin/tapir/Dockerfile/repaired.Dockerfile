FROM python:3.10
ENV PYTHONUNBUFFERED=1
WORKDIR /app
COPY . /app

RUN apt update -y && apt install --no-install-recommends -y libldap2-dev libsasl2-dev gettext && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir poetry && poetry install && poetry run python manage.py compilemessages
