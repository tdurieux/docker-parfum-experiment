FROM python:3.8.3-slim

ADD flask/requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

ADD flask/ ./
CMD python application.py