FROM amazon/aws-cli

RUN yum update -y

RUN yum -y install python3 python3-wheel python-pi && rm -rf /var/cache/yum
COPY / /app

WORKDIR /app

RUN pip3 install --no-cache-dir -r requirements.txt

ENTRYPOINT ["python3"]
EXPOSE 80
CMD ["app.py"]
