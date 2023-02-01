FROM ubuntu:latest
ADD . /code
MAINTAINER Rajdeep Dua "dua_rajdeep@yahoo.com"
RUN apt-get update -y && apt-get install --no-install-recommends -y python-pip python-dev build-essential && rm -rf /var/lib/apt/lists/*;
WORKDIR /code
RUN pip install --no-cache-dir -r requirements.txt

CMD ["python", "FLASK-API/api/interface/data_clean.py"]
CMD ["python", "FLASK-API/api/interface/server.py 3000"]
CMD ["python", "FLASK-API/api/interface/client.py"]
