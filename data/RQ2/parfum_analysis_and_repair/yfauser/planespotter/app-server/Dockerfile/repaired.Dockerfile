FROM tiangolo/uwsgi-nginx-flask:flask
RUN pip install --no-cache-dir Flask-Restless
RUN pip install --no-cache-dir PyMySQL
RUN pip install --no-cache-dir Flask-SQLAlchemy
RUN pip install --no-cache-dir requests
RUN pip install --no-cache-dir redis
COPY uwsgi.ini /etc/uwsgi/uwsgi.ini
COPY ./uwsgi-streaming.conf /etc/nginx/conf.d/
COPY ./app /app
