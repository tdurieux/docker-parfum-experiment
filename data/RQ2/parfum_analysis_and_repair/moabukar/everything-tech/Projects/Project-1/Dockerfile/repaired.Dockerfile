FROM python:3.8

ADD main.py .

RUN pip install --no-cache-dir requests beautifulsoup4

CMD [ "python", "./main.py" ]
