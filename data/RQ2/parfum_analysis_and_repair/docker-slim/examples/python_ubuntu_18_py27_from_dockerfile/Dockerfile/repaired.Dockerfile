FROM ubuntu:18.04
RUN apt-get update && apt-get install --no-install-recommends -y python-pip python-dev build-essential && rm -rf /var/lib/apt/lists/*;

COPY service /opt/app
WORKDIR /opt/app
RUN pip install --no-cache-dir -r requirements.txt

EXPOSE 1300
ENTRYPOINT ["python"]
CMD ["server.py"]
