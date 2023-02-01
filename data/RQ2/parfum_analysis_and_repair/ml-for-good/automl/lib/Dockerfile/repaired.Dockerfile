FROM tensorflow/tensorflow:2.8.0-gpu
RUN cd / && git clone https://github.com/ml-for-good/automl.git
RUN pip install --no-cache-dir -r /automl/lib/requirements.txt
