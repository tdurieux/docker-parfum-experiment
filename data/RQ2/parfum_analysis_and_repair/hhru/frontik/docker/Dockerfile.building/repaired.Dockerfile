FROM registry.pyn.ru/python3.7-ubuntu18-production:2020.12.28

COPY frontik-test setup.py requirements.txt README.md MANIFEST.in /home/building/
COPY frontik /home/building/frontik/
COPY tests /home/building/tests/
COPY examples /home/building/examples/
COPY scripts /home/building/scripts/
WORKDIR /home/building

RUN pip3 install --no-cache-dir --upgrade pip && pip3 install --no-cache-dir --prefer-binary raven && pip3 install --no-cache-dir --prefer-binary -r requirements.txt
RUN python3.7 setup.py test
