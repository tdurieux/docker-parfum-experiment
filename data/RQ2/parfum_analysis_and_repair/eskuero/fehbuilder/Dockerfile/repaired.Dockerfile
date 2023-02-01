FROM python:slim
COPY requirements.txt /
RUN pip3 install --no-cache-dir -r /requirements.txt
COPY app /app
COPY start.sh /
ENTRYPOINT ["./start.sh"]
