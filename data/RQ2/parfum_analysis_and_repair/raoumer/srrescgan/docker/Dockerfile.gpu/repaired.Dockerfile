FROM pytorch/pytorch:1.7.0-cuda11.0-cudnn8-devel

RUN apt-get update && apt-get install --no-install-recommends -y libgl1-mesa-dev libglib2.0-0 && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir \
        numpy==1.20.0 \
        opencv-python==4.5.1.48

COPY srrescgan_code_demo /code
WORKDIR /code

ENTRYPOINT ["python", "test_srrescgan.py"]
