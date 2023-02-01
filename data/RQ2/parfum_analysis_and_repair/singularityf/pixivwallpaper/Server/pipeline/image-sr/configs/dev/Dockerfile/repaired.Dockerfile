FROM tensorflow/tensorflow:latest-gpu

WORKDIR /usr/src/app
COPY . .

RUN apt update && apt install --no-install-recommends -y vim && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir --upgrade pip && pip install --no-cache-dir -r requirements.txt
CMD ["sh", "-c", "tail -f /dev/null"]