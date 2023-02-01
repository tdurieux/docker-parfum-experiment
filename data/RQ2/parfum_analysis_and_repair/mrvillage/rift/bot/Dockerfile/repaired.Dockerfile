FROM python:3.10-slim-buster

WORKDIR /

COPY requirements.txt requirements.txt

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install --no-install-recommends -y git gcc && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir -r requirements.txt

COPY . .

CMD ["python3",  "-O", "start.py"]
