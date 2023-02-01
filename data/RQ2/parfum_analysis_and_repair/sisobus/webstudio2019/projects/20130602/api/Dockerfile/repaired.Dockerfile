FROM tiangolo/uwsgi-nginx-flask:python3.7

COPY requirements.txt /tmp/
RUN pip install --no-cache-dir -r /tmp/requirements.txt && \
	rm /tmp/requirements.txt

COPY ./app /app