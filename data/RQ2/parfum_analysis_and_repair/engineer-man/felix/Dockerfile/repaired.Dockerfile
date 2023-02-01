# pull official base image
FROM python:3.10.2
ADD requirements.txt /app/
RUN pip install --no-cache-dir -U -r /app/requirements.txt
