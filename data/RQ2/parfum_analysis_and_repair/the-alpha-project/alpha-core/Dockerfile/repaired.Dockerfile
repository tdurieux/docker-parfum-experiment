FROM python:3.9-slim-buster

RUN apt update && apt install --no-install-recommends -y gcc && rm -rf /var/lib/apt/lists/*;

WORKDIR /var/wow/
COPY requirements.txt ./
RUN pip3 install --no-cache-dir -r requirements.txt

CMD python3 main.py