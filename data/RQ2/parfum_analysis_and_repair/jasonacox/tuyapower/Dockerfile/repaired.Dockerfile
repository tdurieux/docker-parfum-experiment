FROM python:3
ADD test.py /
ADD tuyapower /tuyapower
RUN pip install --no-cache-dir pycryptodome# or pycrypto, pyaes, Crypto
RUN pip install --no-cache-dir tinytuya
ENV PYTHONPATH "${PYTONPATH}:/tuyapower"
CMD [ "python", "./test.py" ]
