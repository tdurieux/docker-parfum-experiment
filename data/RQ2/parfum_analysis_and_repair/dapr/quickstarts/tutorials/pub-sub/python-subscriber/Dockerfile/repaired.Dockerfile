FROM python:3.7-alpine
COPY . /app
WORKDIR /app
RUN pip install --no-cache-dir flask flask_cors
EXPOSE 5001
CMD ["python", "app.py"]
