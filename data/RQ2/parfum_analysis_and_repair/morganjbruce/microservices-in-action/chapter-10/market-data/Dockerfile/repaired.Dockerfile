FROM python:3.8
ADD . /app
WORKDIR /app
RUN pip install --no-cache-dir -r requirements.txt
CMD ["gunicorn", "-c", "config.py", "service:app"]
EXPOSE 8000
