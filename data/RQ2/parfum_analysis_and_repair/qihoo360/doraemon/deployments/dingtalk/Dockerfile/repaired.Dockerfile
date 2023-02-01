From  python:3.6.10-alpine3.11
RUN pip install --no-cache-dir flask && pip install --no-cache-dir requests && pip install --no-cache-dir datetime
ADD  doraemontodingtalk.py   /doraemontodingtalk.py
EXPOSE 8100
CMD python /doraemontodingtalk.py
