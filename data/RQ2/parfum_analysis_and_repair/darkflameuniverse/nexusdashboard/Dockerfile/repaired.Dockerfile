FROM python:3.8-slim-buster

RUN apt update
RUN apt -y --no-install-recommends install zip && rm -rf /var/lib/apt/lists/*;
RUN apt -y --no-install-recommends install imagemagick && rm -rf /var/lib/apt/lists/*;

COPY requirements.txt requirements.txt

RUN pip install --no-cache-dir -r requirements.txt
RUN pip install --no-cache-dir gunicorn

COPY wsgi.py wsgi.py
COPY entrypoint.sh entrypoint.sh
COPY ./app /app
COPY ./migrations /migrations

EXPOSE 8000
RUN chmod +x entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
