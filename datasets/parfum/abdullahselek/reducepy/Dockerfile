FROM python:3.6-alpine
ADD . /code
WORKDIR /code
RUN pip install -r requirements.txt
RUN pip install -e .
CMD ["python", "reducepy/app.py"]
