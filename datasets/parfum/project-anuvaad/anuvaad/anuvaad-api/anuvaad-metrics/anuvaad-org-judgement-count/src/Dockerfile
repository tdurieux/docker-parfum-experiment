FROM python:3.7-slim
RUN apt-get update
COPY / /app
WORKDIR /app
RUN pip3 install --upgrade pip
RUN pip3 install -r requirements.txt
CMD ["python3", "/app/app.py"]