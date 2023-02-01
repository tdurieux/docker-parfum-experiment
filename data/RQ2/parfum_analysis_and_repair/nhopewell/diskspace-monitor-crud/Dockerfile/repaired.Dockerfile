FROM python:3.8-slim-buster

WORKDIR /usr/src/app

COPY . .

RUN pip3 install --no-cache-dir --upgrade pip
RUN pip3 install --no-cache-dir -e .
RUN pip3 install --no-cache-dir -r requirements.txt

WORKDIR /usr/src/app/src/diskspacemonitor


CMD ["uvicorn", "main:app", "--proxy-headers", "--host", "0.0.0.0", "--port", "8000"]
