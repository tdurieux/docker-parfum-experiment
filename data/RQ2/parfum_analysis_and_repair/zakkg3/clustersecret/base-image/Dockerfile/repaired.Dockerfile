FROM python:3.9-slim
ADD requirements.txt /
RUN pip install --no-cache-dir -r requirements.txt
