FROM ubuntu:latest
RUN apt-get update -y && apt-get install --no-install-recommends -y python-pip python-dev && rm -rf /var/lib/apt/lists/*;
COPY . /app
WORKDIR /app
RUN pip install --no-cache-dir -r requirements.txt
ENTRYPOINT ["python"]
CMD ["app.py"]