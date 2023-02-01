FROM python:3.7

COPY . /app
WORKDIR /app
RUN pip install --no-cache-dir .

CMD ["ing-ynab"]
