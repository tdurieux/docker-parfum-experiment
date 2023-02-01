FROM python:3.6.9
COPY / /app
WORKDIR /app
RUN pip3 install --no-cache-dir --upgrade pip
RUN pip3 install --no-cache-dir -r src/requirements.txt
CMD ["python", "/app/src/app.py"]
