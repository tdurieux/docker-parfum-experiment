# Build Data App
FROM python:slim-buster as DATA_APP_BUILDER

RUN pip install --upgrade pip

RUN apt-get -y update
RUN apt-get -y install git

WORKDIR /app/data-app
COPY ./data-app/requirements.txt requirements.txt
RUN pip install --requirement requirements.txt
COPY ./data-app .

# Build Function App
WORKDIR /app/function-app
COPY ./function-app/requirements.txt requirements.txt
RUN pip install --requirement requirements.txt
COPY ./function-app .

#Set user permissions to nonroot 
USER nobody

CMD [ "python", "function_server.py" ]