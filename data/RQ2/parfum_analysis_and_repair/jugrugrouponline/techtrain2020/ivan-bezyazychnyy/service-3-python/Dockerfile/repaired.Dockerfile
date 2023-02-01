FROM python:3
ADD app.py /
RUN pip install --no-cache-dir flask
RUN pip install --no-cache-dir flask_restful
RUN pip install --no-cache-dir requests
CMD [ "python", "./app.py"]
