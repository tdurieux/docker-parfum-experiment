FROM python:alpine
WORKDIR /app
COPY main.py /app
COPY requirements.txt /app
RUN cd /app && pip install --no-cache-dir -r requirements.txt
EXPOSE 8080 80
CMD ["python", "/app/main.py"]
