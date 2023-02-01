FROM python:3.7-alpine
RUN pip install --no-cache-dir requests
ADD statuspage.py statuspage.py
CMD ["python", "statuspage.py"]
