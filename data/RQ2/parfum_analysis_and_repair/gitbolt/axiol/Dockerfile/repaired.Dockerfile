FROM python:3

COPY /axiol /root

WORKDIR /root

RUN pip install --no-cache-dir motor dnspython pillow disnake nltk python-dotenv

CMD ["python3", "-u","bot.py"]
