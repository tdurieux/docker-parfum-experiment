#FROM mcr.microsoft.com/mssql/server:2019-latest
FROM ubuntu:18.04

RUN apt-get update \
 && apt-get install -y sudo
 
RUN apt-get install -y python3.6 python3-pip gcc libssl-dev unixodbc-dev


# We copy just the requirements.txt first to leverage Docker cache
COPY ./requirements.txt /app/requirements.txt

WORKDIR /app

RUN pip3 install -r requirements.txt

COPY . /app

ENTRYPOINT [ "python3" ]

CMD [ "main.py" ]