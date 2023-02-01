FROM joshualevy44/pymethylprocess:0.1.1

RUN pip install --no-cache-dir git+https://github.com/jlevy44/hypopt.git@af59fbed732f5377cda73fdf42f3d4981c2be3ce

RUN pip3 install --no-cache-dir pandas==0.24.1

RUN pip install --no-cache-dir pymethylprocess==0.1.3 --no-deps

ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8
