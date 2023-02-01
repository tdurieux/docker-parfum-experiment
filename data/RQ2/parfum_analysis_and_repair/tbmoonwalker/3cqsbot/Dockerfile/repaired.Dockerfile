FROM python:3.9.10-slim

COPY . /App/
RUN pip install --no-cache-dir -r /App/requirements.txt

WORKDIR /App

ENTRYPOINT ["./start.sh", ""]
