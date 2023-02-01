FROM python:3.7-alpine
COPY . /app
WORKDIR /app
RUN pip install --no-cache-dir flask flask_cors
ENTRYPOINT ["python"]
EXPOSE 5001
CMD ["app.py"]
