FROM python:3.6.8-jessie
RUN mkdir /app
RUN mkdir -p /var/log/uwsgi
WORKDIR /app
COPY requirements.txt .
COPY requirements_dev.txt .
RUN pip install --no-cache-dir -r requirements.txt
RUN pip install --no-cache-dir -r requirements_dev.txt
RUN apt-get update -y && apt-get install --no-install-recommends -y nginx && rm -rf /var/lib/apt/lists/*;
COPY openelections/api/nginx.conf /etc/nginx/nginx.conf
ADD . .
WORKDIR /app/openelections/api
