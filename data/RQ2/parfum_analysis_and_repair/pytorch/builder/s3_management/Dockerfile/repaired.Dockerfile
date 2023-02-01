FROM python:3.8
WORKDIR /work
ADD requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
ADD manage.py .
ENTRYPOINT ["python", "/work/manage.py"]
