FROM tensorflow/tensorflow:2.5.1-gpu
COPY ./code /code
RUN pip install --no-cache-dir -r code/requirements.txt
