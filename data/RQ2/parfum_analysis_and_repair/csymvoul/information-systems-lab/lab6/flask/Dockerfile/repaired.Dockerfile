FROM ubuntu:18.04
RUN apt-get update && apt-get install --no-install-recommends -y python3 python3-pip && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir --upgrade pip
RUN pip3 install --no-cache-dir flask pymongo
RUN mkdir /app
RUN mkdir -p /app/data
COPY service.py /app/service.py 
ADD data /app/data
EXPOSE 5000
WORKDIR /app
ENTRYPOINT [ "python3","-u", "service.py" ]
