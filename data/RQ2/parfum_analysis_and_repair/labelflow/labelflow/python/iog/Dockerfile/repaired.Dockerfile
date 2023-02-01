FROM pytorch/pytorch:1.9.0-cuda10.2-cudnn7-runtime
RUN apt update && apt install --no-install-recommends build-essential ffmpeg libsm6 libxext6 -y && rm -rf /var/lib/apt/lists/*;

WORKDIR /app

COPY . .

RUN pip install --no-cache-dir -r requirements.txt


EXPOSE 5000

CMD ["python", "server.py"]