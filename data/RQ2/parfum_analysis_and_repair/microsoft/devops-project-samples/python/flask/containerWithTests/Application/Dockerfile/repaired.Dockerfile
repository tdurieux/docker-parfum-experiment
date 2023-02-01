FROM ubuntu:16.04
LABEL maintainer="Azure App Service Container Images <appsvc-images@microsoft.com>"
RUN apt-get update -y && apt-get install --no-install-recommends -y python-pip python-dev build-essential && rm -rf /var/lib/apt/lists/*;
COPY . /app
WORKDIR /app
RUN pip install --no-cache-dir -r requirements.txt
ENTRYPOINT ["python"]
EXPOSE 5000
CMD ["runserver.py"]
