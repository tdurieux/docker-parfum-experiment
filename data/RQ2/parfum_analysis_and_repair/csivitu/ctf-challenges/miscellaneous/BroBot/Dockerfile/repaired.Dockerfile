FROM python:3.7-slim
RUN adduser --disabled-password --gecos "" ctf
WORKDIR /ctf
COPY bot.py bot.py
COPY flag.txt flag.txt
RUN chmod 744 flag.txt && \
  chmod 700 bot.py
RUN pip install --no-cache-dir python-telegram-bot
RUN apt update && apt install --no-install-recommends -y \
  espeak \
  && rm -rf /var/lib/apt/lists/*
ENTRYPOINT []
CMD ["python", "bot.py"]