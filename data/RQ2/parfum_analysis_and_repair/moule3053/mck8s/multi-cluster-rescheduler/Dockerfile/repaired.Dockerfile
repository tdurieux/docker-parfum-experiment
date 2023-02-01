FROM python:3.7
RUN pip3 install --no-cache-dir kopf kubernetes
COPY utils.py /utils.py
COPY mcr.py /apprescheduler.py
CMD kopf run --standalone /apprescheduler.py

