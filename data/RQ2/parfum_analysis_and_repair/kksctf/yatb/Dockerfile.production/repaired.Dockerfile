FROM python:3.8

WORKDIR /usr/src

COPY ./requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY ./app ./app
COPY ./main.py .

# /usr/local/bin/uvicorn
ENTRYPOINT [ "python3", "-m", "uvicorn", "main:app"]
CMD ["--log-level=warning", "--host", "0.0.0.0", "--port", "80"]