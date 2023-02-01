FROM python:3.8-buster

RUN pip install --no-cache-dir cryptography==2.8 PyJWT==1.7.1

CMD ["python", "/home/run/main.py"]
