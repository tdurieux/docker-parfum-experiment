# Dockerfile for clamav service
FROM alpine:3.8
# python3 shared with most images
RUN apk add --no-cache \
    python3 py3-pip \
  && pip3 install --no-cache-dir --upgrade pip
# Image specific layers under this line
RUN apk add --no-cache clamav rsyslog wget clamav-libunrar
RUN mkdir -p /logs /data
RUN echo `date`: File created >> /logs/clamscan.log

COPY conf /etc/clamav-custom
COPY start.py /start.py
COPY health.sh /health.sh
COPY scan.sh /scan.sh
RUN chmod +x /health.sh /scan.sh

CMD /start.py
