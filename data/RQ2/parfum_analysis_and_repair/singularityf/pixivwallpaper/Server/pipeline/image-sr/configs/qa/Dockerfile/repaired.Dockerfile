FROM tensorflow/tensorflow:latest-gpu

WORKDIR /usr/src/app
COPY . .

RUN pip install --no-cache-dir --upgrade pip && pip install --no-cache-dir -r requirements.txt
CMD [ "bash", "./exec.sh" ]