FROM python:3.7.0
ADD requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt
ADD ping_pong.py ./

CMD ["python", "ping_pong.py", "serve"]
