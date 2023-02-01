FROM python:alpine3.8
COPY . /app
WORKDIR /app
RUN pip install --no-cache-dir flask
EXPOSE 7000
CMD python ./app.py
