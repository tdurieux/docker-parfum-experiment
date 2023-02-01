FROM library/python:3.6

# Install OpenJDK-11
RUN apt-get update && \
    apt-get install --no-install-recommends -y openjdk-11-jre-headless && rm -rf /var/lib/apt/lists/*;

ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8

COPY requirements.txt requirements.txt

RUN pip3.6 install sklearn
RUN pip3.6 install -r requirements.txt

COPY . .

RUN mkdir /results

CMD ["/bin/bash"]