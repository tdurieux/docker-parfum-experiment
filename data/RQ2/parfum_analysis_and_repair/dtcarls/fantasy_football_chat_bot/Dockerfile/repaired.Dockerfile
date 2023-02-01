FROM python:3.9.9-slim-bullseye

# Install app
ADD . /usr/src/ff_bot
WORKDIR /usr/src/ff_bot
RUN python3 setup.py install

# Launch app
CMD ["python3", "ff_bot/ff_bot.py"]