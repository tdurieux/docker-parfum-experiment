FROM python:3.8
WORKDIR /app

COPY docker/requirements.txt .
COPY src/ .
RUN apt-get update && apt-get install --no-install-recommends python-pip ffmpeg libsm6 libxext6 -y && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir --upgrade pip
RUN pip3 install --no-cache-dir fastapi[all]
RUN pip3 install --no-cache-dir -r requirements.txt
# RUN git clone --recurse-submodules https://git.3dvisionlabs.com/3dvisionlabs/software/hemistereo/pythonsdk.git
WORKDIR pythonsdk
RUN pip3 install --no-cache-dir -r requirements.txt
RUN pip3 install --no-cache-dir .
WORKDIR /app
CMD ["uvicorn", "camera_to_server:app", "--host", "0.0.0.0", "--port", "1234"]
# CMD ["camera_to_server.py"]
# ENTRYPOINT ["python3"]