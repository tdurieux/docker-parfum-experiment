FROM python:3.9
WORKDIR /code
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY autoImport.py .
CMD [ "python", "-u", "./autoImport.py" ]
