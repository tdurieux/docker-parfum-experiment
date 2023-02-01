FROM python:3.9.0-buster

RUN pip install --no-cache-dir -U https://github.com/platformio/platformio-core/archive/develop.zip
RUN platformio update
# To get the test platforms
RUN pip install --no-cache-dir PyYaml
#ENV PATH /code/buildroot/bin/:/code/buildroot/tests/:${PATH}
