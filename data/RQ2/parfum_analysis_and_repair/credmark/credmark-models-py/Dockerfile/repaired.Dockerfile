FROM python:3.10

WORKDIR /usr/local/app

COPY . .
RUN pip install --no-cache-dir -r requirements.txt -r

CMD [ "credmark-dev" ]