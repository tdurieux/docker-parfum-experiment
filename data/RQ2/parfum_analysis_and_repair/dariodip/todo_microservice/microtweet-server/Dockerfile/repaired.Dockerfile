FROM python:3.6

RUN mkdir /code_mt
WORKDIR /code_mt
ADD . /code_mt/
RUN pip install --no-cache-dir -r requirements.txt

EXPOSE 8000
CMD ["python", "app.py"]