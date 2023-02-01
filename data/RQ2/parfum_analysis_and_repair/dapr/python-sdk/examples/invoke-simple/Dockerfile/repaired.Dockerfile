FROM python:3.7-slim

WORKDIR /app

ADD requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY *.py /app/

CMD [ "python", "invoke-receiver.py" ]