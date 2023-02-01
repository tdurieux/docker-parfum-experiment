FROM python:slim
ADD . /app
RUN apt update && apt install --no-install-recommends -y gcc && rm -rf /var/lib/apt/lists/*;
RUN cd /app && pip3 install --no-cache-dir -r requirements.txt
WORKDIR /app
ENTRYPOINT python main.py
