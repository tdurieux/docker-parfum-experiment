FROM tiangolo/uvicorn-gunicorn:python3.8-slim

RUN mkdir /fastapi

COPY . /fastapi

RUN apt-get update -y && apt-get install --no-install-recommends build-essential cmake protobuf-compiler python3-opencv -y && rm -rf /var/lib/apt/lists/*;

WORKDIR /fastapi

RUN pip install --no-cache-dir -r requirements.txt

EXPOSE 8088

RUN chmod +x ./start.sh

CMD ["./start.sh"]
