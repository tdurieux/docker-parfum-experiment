FROM python:3.9

COPY . .

RUN pip3 install --no-cache-dir -r requirements.txt

CMD [ "python3", "bot.py" ]
