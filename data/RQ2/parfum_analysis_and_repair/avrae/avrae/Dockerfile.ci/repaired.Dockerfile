FROM python:3.10

WORKDIR /app
ENV NO_DICECLOUD=1
ENV TESTING=1

COPY requirements.txt .
COPY tests/requirements.txt tests/
RUN pip install --no-cache-dir -r requirements.txt
RUN pip install --no-cache-dir -r tests/requirements.txt

RUN mkdir shared

COPY . .

ENTRYPOINT pytest tests/
