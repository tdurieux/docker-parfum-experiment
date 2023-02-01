FROM tiangolo/uwsgi-nginx-flask:python3.6
RUN pip install --no-cache-dir redis==3.5.3
COPY . /app
