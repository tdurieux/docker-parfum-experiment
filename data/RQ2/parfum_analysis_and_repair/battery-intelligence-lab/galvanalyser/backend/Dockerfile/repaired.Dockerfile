FROM python

RUN mkdir -p /usr/app
WORKDIR /usr/app

RUN apt-get update && apt-get install --no-install-recommends -y postgresql-client && rm -rf /var/lib/apt/lists/*;

COPY . .
RUN pip install --no-cache-dir -e .

ENV FLASK_APP=app.py

EXPOSE 8050
