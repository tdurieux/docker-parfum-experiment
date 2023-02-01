FROM python:3.8-buster

RUN apt-get update && apt-get install --no-install-recommends -y libgl1-mesa-dev && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir \
        numpy==1.20.0 \
        opencv-python==4.5.1.48 \
        torch==1.7.0

COPY srrescgan_code_demo /code
WORKDIR /code

# Change device from cuda to cpu
RUN sed -i "s/torch.device('cuda')/torch.device('cpu')/" test_srrescgan.py

ENTRYPOINT ["python", "test_srrescgan.py"]
