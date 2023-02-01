FROM python:3.9

COPY requirements.txt requirements.txt

RUN pip install --no-cache-dir prospector && \
    pip install --no-cache-dir -r requirements.txt && \
    useradd -ms /bin/bash jenkins

ENV PATH /home/jenkins/.local/bin:$PATH