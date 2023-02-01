FROM python:3.8

WORKDIR /usr/instapy

COPY . .

RUN pip3 install --no-cache-dir wheel && pip3 install --no-cache-dir -r requirements.txt

CMD ["python3", "-u", "main.py"]
