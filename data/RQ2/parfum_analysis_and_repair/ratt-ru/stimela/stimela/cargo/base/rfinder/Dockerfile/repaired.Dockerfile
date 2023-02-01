FROM stimela/base:1.2.0
RUN docker-apt-install python-casacore \
                       xvfb \
                       texmaker \
                       dvipng \
                       python-tk

RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir rfinder -U
RUN pip install --no-cache-dir pillow --upgrade
