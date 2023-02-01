FROM python:3.7-slim-buster

RUN apt-get update -y && apt-get install --no-install-recommends -y nginx supervisor gcc g++ && rm -rf /var/lib/apt/lists/*;

# update pip
RUN pip3 install --no-cache-dir pip --upgrade

# Setup flask application
RUN mkdir -p /deploy/app
COPY app/requirements.txt /deploy/app/requirements.txt
RUN pip install --no-cache-dir -r /deploy/app/requirements.txt
RUN python -m nltk.downloader punkt

# Setup nginx
RUN rm /etc/nginx/sites-enabled/default
COPY config/flask.conf /etc/nginx/sites-available/
RUN ln -s /etc/nginx/sites-available/flask.conf /etc/nginx/sites-enabled/flask.conf
RUN echo "daemon off;" >> /etc/nginx/nginx.conf

RUN ln -s /usr/local/bin/gunicorn /usr/bin/gunicorn
# Setup supervisord
RUN mkdir -p /var/log/supervisor
COPY config/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
#COPY config/gunicorn.conf /etc/supervisor/conf.d/gunicorn.conf

COPY app /deploy/app

EXPOSE 80

# Start processes
CMD ["/usr/bin/supervisord"]

