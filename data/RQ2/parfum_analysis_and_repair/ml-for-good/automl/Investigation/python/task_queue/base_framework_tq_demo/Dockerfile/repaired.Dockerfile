FROM python:3.7-slim-buster
WORKDIR /app_service
COPY . .

RUN pip3 install --no-cache-dir -r requirments.txt
CMD ["python3", "app.py"]