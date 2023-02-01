FROM python:3.7-stretch
ADD requirements.txt .
RUN pip3 install --no-cache-dir -r requirements.txt
ADD sanic_rookout.py .

