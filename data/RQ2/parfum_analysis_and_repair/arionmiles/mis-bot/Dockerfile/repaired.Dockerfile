FROM python:3.6.8-stretch

RUN mkdir /app/

COPY requirements.txt /app

WORKDIR /app

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Start the bot
CMD ["python", "telegram_bot.py"]
