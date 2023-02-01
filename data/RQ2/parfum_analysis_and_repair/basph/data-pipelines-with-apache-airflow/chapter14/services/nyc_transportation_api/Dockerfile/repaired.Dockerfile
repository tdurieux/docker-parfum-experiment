FROM python:3.7-alpine
RUN apk update && \
    apk add --no-cache postgresql-dev gcc python3-dev musl-dev

COPY requirements.txt /app/
RUN pip install --no-cache-dir -r /app/requirements.txt

COPY app.py /app/
COPY templates /app/templates
WORKDIR /app
EXPOSE 5000
ENTRYPOINT ["python"]
CMD ["app.py"]
