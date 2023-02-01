FROM tiangolo/uvicorn-gunicorn:python3.8-slim

RUN apt-get update -y && apt-get install --no-install-recommends build-essential cmake protobuf-compiler python3-opencv -y && rm -rf /var/lib/apt/lists/*;
RUN python -m pip install --upgrade pip



RUN mkdir /fastapi

COPY requirements.txt /fastapi

WORKDIR /fastapi

RUN pip install --no-cache-dir -r requirements.txt --ignore-installed

COPY . /fastapi

EXPOSE 8088

COPY ./start.sh /start.sh

RUN chmod +x /start.sh

CMD ["/start.sh"]
