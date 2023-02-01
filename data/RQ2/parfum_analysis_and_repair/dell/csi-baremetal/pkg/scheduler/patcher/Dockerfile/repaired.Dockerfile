FROM python:3.10-alpine3.16

COPY requirements.txt main.py /patcher/
WORKDIR /patcher

RUN pip3 install --no-cache-dir -r requirements.txt

ENTRYPOINT ["python3","main.py"]
