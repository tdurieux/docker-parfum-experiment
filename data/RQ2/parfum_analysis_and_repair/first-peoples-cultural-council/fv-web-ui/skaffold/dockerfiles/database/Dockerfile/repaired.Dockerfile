FROM python:3.9.5-alpine
RUN apk add --no-cache postgresql-client
ADD requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
ADD *.py .
CMD ["python", "restoredb.py"]
