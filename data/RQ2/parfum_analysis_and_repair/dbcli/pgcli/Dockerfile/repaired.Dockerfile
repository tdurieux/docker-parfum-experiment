FROM python:3.8

COPY . /app
RUN cd /app && pip install --no-cache-dir -e .

CMD pgcli
