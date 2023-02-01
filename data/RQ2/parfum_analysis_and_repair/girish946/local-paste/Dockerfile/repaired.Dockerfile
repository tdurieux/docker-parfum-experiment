FROM python:3.7-alpine
RUN pip install --no-cache-dir --upgrade pip
RUN mkdir /db
RUN chmod 775 /db
ADD . /code
WORKDIR /code
RUN pip install --no-cache-dir -r requirements.txt
# CMD ["python", "startLp.py"]
CMD ["gunicorn", "wsgi:app", "-b", "0.0.0.0:8000", "--workers=2"]
