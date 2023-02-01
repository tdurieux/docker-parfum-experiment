FROM python:3

ADD requirements.txt requirements.txt
RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir -r requirements.txt

ADD consumer.py consumer.py

CMD [ "python", "consumer.py" ]