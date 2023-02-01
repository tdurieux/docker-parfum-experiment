FROM arm32v7/python:3.7-slim-buster

WORKDIR /app

# custom installation for RPI Grove dependencies defined in requirements.txt
RUN apt-get update && apt-get install --no-install-recommends -y gcc && rm -rf /var/lib/apt/lists/*;

COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

CMD [ "python3", "-u", "./main.py" ]