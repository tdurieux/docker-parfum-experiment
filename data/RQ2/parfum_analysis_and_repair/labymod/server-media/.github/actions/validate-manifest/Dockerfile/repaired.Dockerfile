FROM python:3-buster

COPY ./ /

RUN pip install --no-cache-dir -r requirements.txt

CMD ["python", "-u", "/validate.py"]