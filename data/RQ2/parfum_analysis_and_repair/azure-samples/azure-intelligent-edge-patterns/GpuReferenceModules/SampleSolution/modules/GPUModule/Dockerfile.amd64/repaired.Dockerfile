#FROM amd64/python:3.7-slim-buster
#FROM nvcr.io/nvidia/tensorflow:19.12-tf1-py3
#FROM nvcr.io/nvidia/tensorflow:20.03-tf2-py3
FROM nvcr.io/nvidia/tensorflow:20.10-tf2-py3
WORKDIR /app

COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

CMD [ "python3", "-u", "./main.py" ]
