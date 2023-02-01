FROM ubuntu:latest
RUN apt-get update -y && apt-get install --no-install-recommends -y python-pip python-dev build-essential && rm -rf /var/lib/apt/lists/*;
RUN apt-get upgrade -y

COPY . /iiify
WORKDIR /iiify
RUN pip install --no-cache-dir -r requirements.txt
ENTRYPOINT ["python"]
EXPOSE 8080
CMD ["/iiify/iiify/app.py"]
