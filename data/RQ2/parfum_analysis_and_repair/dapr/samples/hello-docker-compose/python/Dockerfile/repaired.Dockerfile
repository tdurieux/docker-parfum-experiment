FROM python:3.7.1-alpine3.8
WORKDIR /app
COPY . .
RUN pip install --no-cache-dir requests
ENTRYPOINT ["python"]
CMD ["app.py"]
