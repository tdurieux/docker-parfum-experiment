FROM python:3.7.8-slim-buster

WORKDIR /usr/app

EXPOSE 5000

COPY requirements.txt .
COPY requirements.deploy.txt .

RUN pip install --no-cache-dir -U pip
RUN pip install --no-cache-dir -r requirements.txt
RUN pip install --no-cache-dir -r requirements.deploy.txt

COPY README.md .
COPY wsgi.py .
COPY ./vocprez ./vocprez

CMD ["gunicorn", "-w", "5", "-b", "0.0.0.0:5000",  "--access-logfile", "-", "--error-logfile", "-", "wsgi:application"]
