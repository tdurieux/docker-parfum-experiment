FROM python:3
RUN pip install --no-cache-dir pystrich
CMD [ "echo", "\"success\"" ]
