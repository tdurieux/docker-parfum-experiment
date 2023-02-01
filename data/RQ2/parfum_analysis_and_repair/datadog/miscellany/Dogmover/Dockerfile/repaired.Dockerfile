FROM python:3-slim

WORKDIR /dogmover
COPY requirements.txt requirements.txt

RUN pip install --no-cache-dir -r requirements.txt --upgrade

ENTRYPOINT ["./dogmover.py"]
