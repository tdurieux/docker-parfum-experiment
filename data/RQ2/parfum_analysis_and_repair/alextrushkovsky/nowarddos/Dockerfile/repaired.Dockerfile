# Base image
FROM python:3.8-alpine

COPY *.py /nowarddos/
COPY requirements.txt /nowarddos/

WORKDIR /nowarddos
RUN pip install --no-cache-dir -r requirements.txt

ENTRYPOINT ["python3", "/nowarddos/main.py"]
