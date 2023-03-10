FROM dymat/opencv

WORKDIR /app

RUN apt-get update && \
    apt-get install -y --no-install-recommends libcurl4-openssl-dev python3-pip libboost-python1.58-dev libpython3-dev && \
    rm -rf /var/lib/apt/lists/*

RUN pip3 install --no-cache-dir --upgrade pip

COPY requirements.txt ./
RUN pip install --no-cache-dir setuptools
RUN pip install --no-cache-dir opencv-python
RUN pip install --no-cache-dir -r requirements.txt
COPY . .

RUN useradd -ms /bin/bash moduleuser
USER moduleuser

CMD [ "python3", "-u", "./main.py" ]