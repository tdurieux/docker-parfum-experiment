FROM python:3-alpine

WORKDIR /app
ADD canvas_intro_stats.py ./

RUN pip install --no-cache-dir elasticsearch pytz

CMD [ "python", "./canvas_intro_stats.py" ]
