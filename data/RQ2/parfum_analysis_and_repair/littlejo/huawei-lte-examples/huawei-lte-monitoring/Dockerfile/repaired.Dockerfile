FROM python:3.7.2-alpine3.8

ADD requirements.txt /
RUN pip install --no-cache-dir -r requirements.txt
ADD * /
ENTRYPOINT python display_traffic_signal.py
