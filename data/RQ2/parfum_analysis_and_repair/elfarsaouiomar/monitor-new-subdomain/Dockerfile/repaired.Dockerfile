FROM python:3.11.0b1

ADD . /app

WORKDIR /app

RUN pip install --no-cache-dir -r requirements.txt

ENTRYPOINT ["python3","check-new-subdomain.py"]