FROM python:3.7.0
ADD requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt
ADD mybitcoin.py ./

CMD ["python", "-u", "mybitcoin.py", "serve"]
