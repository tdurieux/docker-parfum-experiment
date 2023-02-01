ARG BASE_PYTHON_ALPINE
FROM $BASE_PYTHON_ALPINE
COPY monitoring-ping.py requirements.txt /
WORKDIR /
RUN pip3 install --no-cache-dir --upgrade pip && pip3 install --no-cache-dir -r requirements.txt && apk add --no-cache fping
ENTRYPOINT ["python3", "/monitoring-ping.py"]
