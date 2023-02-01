FROM python:2.7-alpine

WORKDIR /app

ADD echo.py /app/
ADD requirements.txt /app/

RUN pip install --no-cache-dir -r requirements.txt

CMD ["python echo.py"]