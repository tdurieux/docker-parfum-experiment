FROM python:3.8

WORKDIR /app
COPY src/* /app/

RUN pip install --no-cache-dir -r requirements.txt

ENTRYPOINT ["python3"]
CMD ["app.py"]