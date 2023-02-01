FROM python:3.7-buster
WORKDIR /app
ADD requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
ADD . .
ENTRYPOINT [ "python3", "app/bot.py" ]