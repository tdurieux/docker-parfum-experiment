FROM python:3.7.0
ADD requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt
ADD utils.py ./
ADD identities.py ./
ADD mypowcoin.py ./

CMD ["python", "-u", "mypowcoin.py", "serve"]
