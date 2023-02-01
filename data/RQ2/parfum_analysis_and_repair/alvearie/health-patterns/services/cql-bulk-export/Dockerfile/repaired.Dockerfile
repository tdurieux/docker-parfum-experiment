FROM python:3.8-slim-buster

WORKDIR /app
ENV FLASK_APP=bulkextract.py

RUN pip3 install --no-cache-dir flask
RUN pip3 install --no-cache-dir flask-restful
RUN pip3 install --no-cache-dir requests
RUN pip3 install --no-cache-dir ibm-cos-sdk

COPY . .

CMD [ "python3", "-m" , "flask", "run", "--host=0.0.0.0"]
