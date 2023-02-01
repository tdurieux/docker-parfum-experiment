FROM tiangolo/uwsgi-nginx-flask:python3.7
COPY . /app
RUN pip install --no-cache-dir -r requirements.txt



