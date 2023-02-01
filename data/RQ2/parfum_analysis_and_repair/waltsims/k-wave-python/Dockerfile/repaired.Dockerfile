FROM python:3.7.0-slim

RUN apt-get update && apt-get install --no-install-recommends -y gfortran libopenblas-dev liblapack-dev libgl1-mesa-glx libglib2.0-0 libgl1-mesa-glx libglib2.0-0 && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir --upgrade pip
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
RUN pip install --no-cache-dir pytest
