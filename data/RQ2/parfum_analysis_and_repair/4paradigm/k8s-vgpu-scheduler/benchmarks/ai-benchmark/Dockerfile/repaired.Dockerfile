FROM tensorflow/tensorflow:2.4.1-gpu

RUN apt-get update && apt-get install -y --no-install-recommends apt-utils && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir --upgrade pip

RUN apt-get -y --no-install-recommends install git && rm -rf /var/lib/apt/lists/*;
RUN git clone -b feat/transformer https://github.com/shiyoubun/ai-benchmark.git

WORKDIR ai-benchmark
RUN pip install --no-cache-dir -e .

ENTRYPOINT [ "python", "bin/ai-benchmark.py" ]
