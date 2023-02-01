FROM python:3.6
WORKDIR /app
ADD . /app
RUN pip install --no-cache-dir -r requirements.txt
CMD ["python", "start.py"]