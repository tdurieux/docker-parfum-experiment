FROM pytorch/pytorch:1.9.0-cuda11.1-cudnn8-runtime

# Lib dependencies
RUN apt-get update && apt-get install --no-install-recommends -y ffmpeg build-essential && rm -rf /var/lib/apt/lists/*;

# Setup
WORKDIR /app
COPY application/ /app/application
COPY dataset/ /app/dataset
COPY training/ /app/training
COPY synthesis/ /app/synthesis
COPY main.py /app
COPY requirements.txt /app

# Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Start app
CMD [ "python3", "main.py" ]
