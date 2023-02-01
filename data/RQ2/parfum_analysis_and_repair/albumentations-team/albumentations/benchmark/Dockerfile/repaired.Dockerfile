FROM python:3.9.5

RUN apt-get update -y && apt install --no-install-recommends libgl1-mesa-glx -y && rm -rf /var/lib/apt/lists/*;

ENV DATA_DIR /images

WORKDIR /albumentations
COPY . .

RUN pip install -U --no-cache-dir pip
RUN pip install -U --no-cache-dir -e .
RUN pip install -U --no-cache-dir -r ./benchmark/requirements.txt

WORKDIR /albumentations/benchmark

ENTRYPOINT ["python", "benchmark.py"]
