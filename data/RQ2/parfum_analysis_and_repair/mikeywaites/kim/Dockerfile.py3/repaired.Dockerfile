FROM python:3.7


ADD . /opt/code
WORKDIR /opt/code/

RUN pip install --no-cache-dir -e .[develop]
CMD ["python", "setup.py", "test"]
