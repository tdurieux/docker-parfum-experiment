ARG FROM_IMAGE_NAME
FROM ${FROM_IMAGE_NAME}

RUN apt install --no-install-recommends libgl1-mesa-glx -y && rm -rf /var/lib/apt/lists/*;
COPY requirements.txt .
RUN pip3.7 install -r requirements.txt
