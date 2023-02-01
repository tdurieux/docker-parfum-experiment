FROM python:3.7-alpine
WORKDIR /app
COPY . /app
RUN rm -rf ./components
RUN pip install --no-cache-dir requests
ENTRYPOINT ["python"]
CMD ["app.py"]
