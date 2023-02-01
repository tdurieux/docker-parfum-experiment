FROM python:3.8-alpine
RUN pip install --no-cache-dir flask
COPY . /app
WORKDIR /app
ENTRYPOINT ["python"]
CMD ["app.py"]
