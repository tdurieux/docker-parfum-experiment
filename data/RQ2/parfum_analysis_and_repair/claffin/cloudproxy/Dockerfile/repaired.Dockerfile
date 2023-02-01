FROM nikolaik/python-nodejs:python3.8-nodejs15-slim

ENV PYTHONPATH "$PYTHONPATH:/app"

EXPOSE 8000

COPY . /app
WORKDIR /app/cloudproxy-ui

RUN npm install && npm cache clean --force;
RUN npm run build

WORKDIR /app

RUN pip install --no-cache-dir -r requirements.txt

ENTRYPOINT ["python","./cloudproxy/main.py"]