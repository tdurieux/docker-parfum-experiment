FROM python:3.10.5

WORKDIR /app

RUN apt-get -y update && apt-get -y --no-install-recommends install git gcc python3-dev && rm -rf /var/lib/apt/lists/*;

COPY requirements.txt requirements.txt

RUN pip3 install --no-cache-dir -U -r requirements.txt

COPY . .

CMD [ "python3", "-m" , "Cutiepii_Robot"]
