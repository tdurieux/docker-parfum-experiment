FROM library/python:3.9-buster

COPY requirements.txt /

RUN pip install --no-cache-dir -r /requirements.txt

RUN mkdir /app
COPY src /app/

CMD python3 /app/ransomwatch.py
