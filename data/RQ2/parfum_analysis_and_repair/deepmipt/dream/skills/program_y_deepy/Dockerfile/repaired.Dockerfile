FROM python:3.7.4

WORKDIR /app

COPY requirements.txt requirements.txt
RUN pip install --no-cache-dir -r requirements.txt
COPY . .

CMD cd dream_aiml/scripts/xnix && ./sanic.sh
