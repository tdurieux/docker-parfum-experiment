FROM docker.io/debian:11.3

WORKDIR /app

ENV FLASK_APP=app.py

RUN apt-get update \
    && apt-get install --no-install-recommends -y \
        dumb-init \
        python3-flask \
        python3-jinja2 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

EXPOSE 5000

COPY flask .

CMD ["/usr/bin/dumb-init", "--", "flask", "run", "--port", "5000", "--host", "0.0.0.0"]
