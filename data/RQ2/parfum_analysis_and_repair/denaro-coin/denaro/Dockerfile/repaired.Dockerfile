FROM python:3.10.1-slim-buster

WORKDIR /app
COPY . .

RUN apt-get update -y && apt-get upgrade -y
RUN apt-get install --no-install-recommends -y libgmp3-dev gcc && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir -r requirements.txt

RUN sed -i 's/node.main:app/denaro.node.main:app/' run_node.py

CMD ["python", "run_node.py"]