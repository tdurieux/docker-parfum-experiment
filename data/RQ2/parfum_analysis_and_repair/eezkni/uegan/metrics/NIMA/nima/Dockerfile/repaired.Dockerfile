FROM floydhub/dl-base:3.0.0-gpu-py3.22

ENV LC_ALL C.UTF-8
ENV LANG C.UTF-8

RUN apt-get update && apt-get install --no-install-recommends -y python3-tk zlib1g-dev libjpeg-dev && rm -rf /var/lib/apt/lists/*;


ENV APP_DIR /app
WORKDIR $APP_DIR

# if CPU SSE4-capable add pillow-simd with AVX2-enabled version
RUN pip uninstall -y pillow
RUN CC="cc -mavx2" pip --no-cache-dir install -U --force-reinstall pillow-simd


COPY requirements.txt requirements.txt
RUN pip install --no-cache-dir -r requirements.txt
COPY . $APP_DIR
