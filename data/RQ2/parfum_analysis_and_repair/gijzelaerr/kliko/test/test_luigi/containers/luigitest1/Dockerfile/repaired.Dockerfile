FROM kernsuite/base:dev
RUN pip install --no-cache-dir kliko==0.7.1
ADD kliko /
ADD kliko.yml /
