FROM python:3.7

WORKDIR /app

ADD requirements.txt /app/requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

ENTRYPOINT ["python", "app.py"]

COPY . /app

