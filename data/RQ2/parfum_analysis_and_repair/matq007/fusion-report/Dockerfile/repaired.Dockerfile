FROM python:3.9.7

COPY . .

RUN apt-get -y update && apt-get -y --no-install-recommends install sqlite3 && rm -rf /var/lib/apt/lists/*;

RUN pip3 install --no-cache-dir -r requirements.txt && python3 setup.py install