FROM python:alpine3.15
COPY . /app
WORKDIR /app
RUN pip3 install --no-cache-dir -r requirement.txt
USER 1000:1000
CMD ["python3", "main.py"]
