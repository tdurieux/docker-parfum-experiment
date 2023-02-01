FROM ubuntu:16.04
RUN apt-get update && \
    apt-get install --no-install-recommends -y postgresql-server-dev-all && \
    apt-get install --no-install-recommends -y python3-dev && \
    apt-get install --no-install-recommends -y python3-pip && \
    apt-get install --no-install-recommends -y libgeos-dev && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir uwsgi
ADD /requirements.txt /app/
WORKDIR /app
RUN pip3 install --no-cache-dir -r requirements.txt
CMD uwsgi --http :8080 --wsgi-file backend.py --callable app
