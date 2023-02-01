FROM python:3.6
ADD . /app
WORKDIR /app
RUN pip install --no-cache-dir -r requirements.txt
CMD ["gunicorn", "-c", "config.py", "app:app"]
EXPOSE 8000
