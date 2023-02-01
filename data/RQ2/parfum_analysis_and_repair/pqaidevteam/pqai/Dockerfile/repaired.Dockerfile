FROM python:3.7-slim
ADD requirements.txt /app/requirements.txt
RUN apt-get update && apt-get install --no-install-recommends gcc g++ -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends libgl1-mesa-glx libglib2.0-0 libsm6 libxrender1 libxext6 -y && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir -r /app/requirements.txt
WORKDIR /app
COPY . .
CMD [ "python3", "server.py"]