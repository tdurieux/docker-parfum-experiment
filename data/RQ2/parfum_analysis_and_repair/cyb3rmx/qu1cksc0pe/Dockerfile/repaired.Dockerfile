FROM python:3.7

WORKDIR /app

COPY requirements.txt requirements.txt
RUN pip3 install --no-cache-dir -r requirements.txt

COPY . .

ENTRYPOINT ["/app/qu1cksc0pe.py"]
