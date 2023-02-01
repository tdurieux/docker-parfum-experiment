FROM python:3.7

WORKDIR /app

COPY . .

RUN set -xe; \
    pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

CMD [ "python3", "vulmap.py" ]