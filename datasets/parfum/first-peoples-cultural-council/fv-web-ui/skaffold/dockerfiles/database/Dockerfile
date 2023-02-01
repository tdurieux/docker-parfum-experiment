FROM python:3.9.5-alpine
RUN apk add postgresql-client
ADD requirements.txt .
RUN pip install -r requirements.txt
ADD *.py .
CMD ["python", "restoredb.py"]
