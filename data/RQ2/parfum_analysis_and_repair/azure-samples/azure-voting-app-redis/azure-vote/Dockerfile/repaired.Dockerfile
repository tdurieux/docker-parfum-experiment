FROM tiangolo/uwsgi-nginx-flask:python3.6
RUN pip install --no-cache-dir redis
ADD /azure-vote /app
