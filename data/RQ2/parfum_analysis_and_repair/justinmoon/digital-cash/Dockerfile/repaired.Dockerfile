FROM python:3.7.0
ADD requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt
ADD blockcoin.py ./
ADD utils.py ./
ADD identities.py ./

CMD ["python", "blockcoin.py", "serve"]
