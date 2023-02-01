ARG FROM_IMAGE_NAME
FROM ${FROM_IMAGE_NAME}
RUN apt update && apt install --no-install-recommends libgeos-dev -y && rm -rf /var/lib/apt/lists/*;

COPY requirements.txt .
RUN pip3.7 install -r requirements.txt
