FROM python:2
WORKDIR /src
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY local_aes .
CMD [ "./local_aes" ]