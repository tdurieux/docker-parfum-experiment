FROM python:3.9.2

RUN apt update \
  && apt install -y --no-install-recommends graphviz && rm -rf /var/lib/apt/lists/*;

COPY . .

RUN pip3 install --no-cache-dir -r requirements.txt

ENV PYTHONUNBUFFERED=TRUE

ENTRYPOINT ["python3", "bot.py"]
