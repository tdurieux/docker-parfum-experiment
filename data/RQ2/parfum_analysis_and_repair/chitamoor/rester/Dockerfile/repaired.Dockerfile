FROM python:2.7
RUN pip install --no-cache-dir git+https://github.com/chitamoor/Rester.git@master
ADD rester/examples examples
