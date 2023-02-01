FROM python:3.6

COPY ./requirements.txt /pip/
RUN pip3 install --no-cache-dir -r /pip/requirements.txt

COPY . /travian-bot/
WORKDIR /travian-bot

CMD ["python", "./main.py"]