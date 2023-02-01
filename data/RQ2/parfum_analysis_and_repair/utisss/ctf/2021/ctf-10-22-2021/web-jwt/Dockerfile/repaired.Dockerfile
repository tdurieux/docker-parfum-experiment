FROM python:3.8-alpine3.13

WORKDIR /usr/src/app
RUN apk update && apk add --no-cache python3-dev

RUN pip install --no-cache-dir --upgrade pip
COPY /requirements.txt /usr/src/app/requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

COPY . /usr/src/app

EXPOSE 5000

ENTRYPOINT ["python3"]

CMD ["/usr/src/app/app.py"]
