FROM python:3.8-slim-buster


WORKDIR /code
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
RUN pip install --no-cache-dir gunicorn
COPY . .
ENV FLASK_APP rcon.connection
ENV PYTHONPATH /code/
RUN chmod +x entrypoint.sh
RUN chmod +x manage.py
