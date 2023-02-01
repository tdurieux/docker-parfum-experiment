FROM python:3.9.1-buster

WORKDIR /root/Natsuki

COPY . .

RUN pip3 install --no-cache-dir --upgrade pip setuptools

RUN pip install --no-cache-dir -U -r requirements.txt

CMD ["python3","-m","Natsuki"]
