FROM python:3.7

# Install Chromium for rendering Altair charts to PNG
# Fixed version to preserve compatibility with chromedriver
# in case the two releases get out of sync
RUN apt-get update && apt-get install --no-install-recommends -y \
    chromium=80.0.3987.149-1~deb10u1 \
    chromium-driver=80.0.3987.149-1~deb10u1 \
    && rm -rf /var/lib/apt/lists/*

# Copy essentials in to install requirements
COPY ./setup.py ./meta.json ./requirements.txt ./README.md /code/
COPY ./benchmark/requirements.txt /code/benchmark/requirements.txt

# Install dependencies
WORKDIR /code
RUN pip install --no-cache-dir -e '.[augment,tokenize]' \
    && pip install --no-cache-dir -r requirements.txt \
    && pip install --no-cache-dir -r benchmark/requirements.txt

# Copy the rest of the repository in
COPY ./ /code

ENTRYPOINT ["python", "run_benchmarks.py"]
