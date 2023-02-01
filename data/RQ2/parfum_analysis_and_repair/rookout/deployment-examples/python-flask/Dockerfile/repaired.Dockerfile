FROM python:3.7-stretch
ADD requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
ADD flask_rookout.py .