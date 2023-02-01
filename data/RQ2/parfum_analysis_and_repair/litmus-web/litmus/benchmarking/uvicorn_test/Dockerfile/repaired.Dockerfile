FROM python:3.8

WORKDIR /app

COPY ./requirements.txt .
COPY ./test.py .

RUN pip install --no-cache-dir -r requirements.txt

CMD ["python", "test.py"]