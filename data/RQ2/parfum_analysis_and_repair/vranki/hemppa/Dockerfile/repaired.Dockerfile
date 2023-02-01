FROM python:3.8-slim

WORKDIR /bot
RUN apt update && apt -y --no-install-recommends install libcups2-dev python3-dev gcc && rm -rf /var/lib/apt/lists/*;

COPY Pipfile .
RUN pip install --no-cache-dir pipenv && \
    pip install --no-cache-dir pipfile-requirements
RUN pipfile2req Pipfile > requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

COPY bot.py *.json *.pickle /bot/
COPY config config
COPY modules modules

VOLUME /bot/config

CMD [ "python", "-u", "./bot.py" ]
