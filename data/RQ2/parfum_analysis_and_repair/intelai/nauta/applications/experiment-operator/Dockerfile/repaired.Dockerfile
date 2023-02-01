FROM python:3.7
ADD requirements.txt /src/requirements.txt
RUN pip install --no-cache-dir -r /src/requirements.txt
ADD . /src
CMD kopf run /src/nauta_operator.py