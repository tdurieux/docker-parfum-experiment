FROM python:3.7-alpine
WORKDIR /app

# set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# install psycopg2 dependencies
RUN apk update && apk add --no-cache \
    build-base \
    ca-certificates \
    musl-dev \
    postgresql-dev \
    python3-dev \
    libffi-dev \
    openldap-dev

COPY requirements*.txt /app/

RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r requirements-ldap.txt

# Django service
EXPOSE 8000

CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]

