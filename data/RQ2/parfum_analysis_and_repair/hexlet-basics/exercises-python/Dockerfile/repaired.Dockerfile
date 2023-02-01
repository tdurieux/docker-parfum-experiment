FROM hexletbasics/base-image

RUN pip3 install --no-cache-dir flake8 pytest
RUN curl -f https://bootstrap.pypa.io/get-pip.py -o get-pip.py && python3 get-pip.py

WORKDIR /exercises-python

COPY . .

ENV PYTHONPATH=/exercises-python/src
# RUN ln -s $(which python3) /usr/bin/python

ENV PATH=/exercises-python/bin:$PATH
