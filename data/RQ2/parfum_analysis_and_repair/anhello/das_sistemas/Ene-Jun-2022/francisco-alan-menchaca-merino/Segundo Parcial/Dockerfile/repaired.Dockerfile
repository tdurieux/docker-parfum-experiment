FROM python:3.9.7
WORKDIR /parcial-2
ADD . /parcial-2
RUN pip install --no-cache-dir -r requirements.txt
CMD ["python", "mongo_db.py"]
