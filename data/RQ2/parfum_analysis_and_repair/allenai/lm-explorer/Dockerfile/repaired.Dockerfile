FROM python:3.6.8

WORKDIR /local
COPY requirements.txt /local/

RUN pip install --no-cache-dir -r requirements.txt

COPY . /local

CMD ["python", "app.py", "--port", "8000"]
