FROM python:3.7-slim

WORKDIR /usr/src/servingservice/storage

COPY requirements.txt ./

RUN pip install --no-cache-dir -r requirements.txt \
    && rm -rf /root/.cache/pip

COPY . .

ENTRYPOINT ["python", "storage_controller.py"]