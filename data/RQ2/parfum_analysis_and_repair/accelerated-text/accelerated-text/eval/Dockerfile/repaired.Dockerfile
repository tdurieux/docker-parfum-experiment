FROM python:3

WORKDIR /usr/src/app

RUN apt-get update && apt-get install --no-install-recommends jq -y && rm -rf /var/lib/apt/lists/*;

COPY . .

RUN pip install --no-cache-dir -r requirements.txt

CMD [ "python", "./eval.py", "E2E", "devset.csv", "data/state.zip", "--strategy", "RANDOM" ]
