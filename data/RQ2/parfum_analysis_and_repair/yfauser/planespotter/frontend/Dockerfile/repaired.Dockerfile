FROM tiangolo/uwsgi-nginx-flask:flask
RUN pip install --no-cache-dir flask-paginate
RUN pip install --no-cache-dir requests
RUN pip install --no-cache-dir netifaces
COPY uwsgi.ini /etc/uwsgi/uwsgi.ini
COPY ./uwsgi-streaming.conf /etc/nginx/conf.d/
COPY ./app /app
