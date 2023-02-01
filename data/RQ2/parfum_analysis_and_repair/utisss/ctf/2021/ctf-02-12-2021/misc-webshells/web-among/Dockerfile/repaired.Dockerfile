FROM python:3
COPY . .
RUN pip install --no-cache-dir flask

CMD ["python","main.py"]
