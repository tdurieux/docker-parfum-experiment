FROM python:3

COPY requirements.txt ./
RUN apt-get update && apt-get install --no-install-recommends -y vim telnet && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir -r requirements.txt
RUN mkdir /www
ADD recommendation-service.py /
ADD debezium-setup.sh /

CMD [ "python3", "/recommendation-service.py" ]
