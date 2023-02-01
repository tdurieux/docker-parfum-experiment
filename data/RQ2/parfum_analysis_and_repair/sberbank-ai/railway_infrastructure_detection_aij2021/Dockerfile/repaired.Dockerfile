FROM cr.msk.sbercloud.ru/aicloud-base-images/horovod-cuda10.2

WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
