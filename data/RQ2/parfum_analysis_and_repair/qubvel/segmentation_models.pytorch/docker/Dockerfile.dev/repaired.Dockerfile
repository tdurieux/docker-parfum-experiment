FROM anibali/pytorch:1.5.0-nocuda

WORKDIR /tmp/smp/

COPY ./requirements.txt /tmp/smp/requirements.txt
RUN pip install --no-cache-dir -r requirements.txt
RUN pip install --no-cache-dir pytest mock

COPY . /tmp/smp/
RUN pip install --no-cache-dir .
