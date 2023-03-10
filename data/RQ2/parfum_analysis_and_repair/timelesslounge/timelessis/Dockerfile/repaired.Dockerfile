FROM python:3.6

COPY . /usr/app
WORKDIR /usr/app

RUN pip install --no-cache-dir -r requirements.txt

EXPOSE 5000
ENTRYPOINT ["./entrypoint.sh"]
