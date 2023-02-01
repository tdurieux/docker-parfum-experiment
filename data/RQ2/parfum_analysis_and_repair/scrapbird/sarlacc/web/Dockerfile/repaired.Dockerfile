FROM python:3.6
ADD ./src /sarlacc
WORKDIR /sarlacc
RUN pip install --no-cache-dir -r requirements.txt
CMD ["python", "app.py"]
