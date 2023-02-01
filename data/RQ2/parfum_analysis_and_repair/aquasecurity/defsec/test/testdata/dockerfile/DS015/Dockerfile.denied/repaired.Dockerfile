FROM alpine:3.5
RUN yum install -y vim && rm -rf /var/cache/yum
RUN pip install --no-cache-dir -r /usr/src/app/requirements.txt
USER mike
CMD python /usr/src/app/app.py