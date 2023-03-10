FROM python:3.8-slim

ENV PYTHONUNBUFFERED True
ENV APP_HOME /app
WORKDIR $APP_HOME
COPY . ./

COPY requirements.txt requirements.txt

RUN apt-get update && apt-get install --no-install-recommends ffmpeg libsm6 libxext6 -y && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir -r requirements.txt

CMD exec gunicorn --bind :$PORT --workers 1 --threads 8 --timeout 0 app:app