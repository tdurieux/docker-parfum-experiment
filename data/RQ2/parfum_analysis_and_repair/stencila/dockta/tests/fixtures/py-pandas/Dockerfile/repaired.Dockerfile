FROM python:3.7.0

# dockta

COPY requirements.txt requirements.txt
RUN pip install --no-cache-dir -r requirements.txt
