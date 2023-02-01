FROM python:3.9

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

ADD src/ config.yaml .

CMD [ "python", "bot.py" ]
