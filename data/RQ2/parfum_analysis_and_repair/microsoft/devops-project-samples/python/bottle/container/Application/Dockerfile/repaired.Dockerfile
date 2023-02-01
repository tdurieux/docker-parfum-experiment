FROM ubuntu:16.04
LABEL maintainer="Azure App Service Container Images <appsvc-images@microsoft.com>"

RUN apt-get update && apt-get install --no-install-recommends -y python-pip python-dev && apt-get clean && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir bottle
RUN mkdir /code
WORKDIR /code
ADD requirements.txt /code/
RUN pip install --no-cache-dir -r requirements.txt
ADD . /code/

EXPOSE 8080 80 5555

CMD ["python","app.py"]
