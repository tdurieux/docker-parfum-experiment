FROM python:3.8-slim

COPY . /app

WORKDIR /app
RUN pip install --no-cache-dir -r requirements.txt

EXPOSE 5000

CMD [ "nameko", "run", "--config", "config.yml", "app" ]