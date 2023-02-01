FROM python:3.8-buster

WORKDIR /code
RUN apt-get update -y && apt-get install --no-install-recommends -y cron logrotate && rm -rf /var/lib/apt/lists/*;
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
RUN pip install --no-cache-dir gunicorn
RUN pip install --no-cache-dir gunicorn[eventlet]
RUN pip install --no-cache-dir supervisor
COPY . .
ENV FLASK_APP rcon.connection
ENV PYTHONPATH /code/
RUN chmod +x entrypoint.sh
RUN chmod +x manage.py

ENTRYPOINT [ "/code/entrypoint.sh" ]
