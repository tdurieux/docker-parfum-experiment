FROM python:3.6-alpine
WORKDIR /app
COPY . /app
RUN pip install --no-cache-dir .

CMD ["./test.sh"]
