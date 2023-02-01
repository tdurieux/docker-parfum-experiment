FROM python:3.6

WORKDIR /app

ADD ./app/requirements.txt /app/requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

ADD . /app

CMD ["python", "./app/forecast.py"]
