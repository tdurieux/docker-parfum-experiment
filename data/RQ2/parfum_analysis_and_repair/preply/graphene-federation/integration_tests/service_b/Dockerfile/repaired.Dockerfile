FROM python:3.6-alpine3.9

WORKDIR project
RUN apk add --no-cache curl

COPY ./requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

EXPOSE 5000
CMD [ "python", "./src/app.py"]
