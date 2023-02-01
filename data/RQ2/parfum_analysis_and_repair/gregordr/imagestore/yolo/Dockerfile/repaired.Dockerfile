FROM jjanzic/docker-python3-opencv
WORKDIR /code
RUN apt-get update && apt-get install --no-install-recommends libgl1-mesa-glx -y && rm -rf /var/lib/apt/lists/*;
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt \
    && pip install --no-cache-dir torch==1.7.1+cpu torchvision==0.8.2+cpu -f https://download.pytorch.org/whl/torch_stable.html \
    && git clone https://github.com/ultralytics/yolov5.git
COPY src/ .
CMD [ "python", "./app.py" ]
