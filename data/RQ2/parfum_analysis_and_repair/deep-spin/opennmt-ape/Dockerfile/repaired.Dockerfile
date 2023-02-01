FROM pytorch/pytorch:latest
RUN git clone https://github.com/OpenNMT/OpenNMT-py.git && cd OpenNMT-py && pip install --no-cache-dir -r requirements.txt && python setup.py install
