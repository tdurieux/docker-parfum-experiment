FROM python:3.6.1-alpine

WORKDIR /app

RUN pip install --no-cache-dir --upgrade pip

COPY . .

RUN pip3 install --no-cache-dir -r requirements.txt

CMD ["python3","app.py"]

