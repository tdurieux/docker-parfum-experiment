FROM node

RUN git clone https://github.com/googlecreativelab/aiexperiments-ai-duet.git
WORKDIR aiexperiments-ai-duet/static \
 && npm install webpack tensorflow -g \
 && npm install \
 && webpack -p

WORKDIR ../server
RUN apt-get update && apt-get install --no-install-recommends -y python-pip python-dev bash && rm -rf /var/lib/apt/lists/*;
RUN pip2 install --no-cache-dir -r requirements.txt

RUN wget https://repo.continuum.io/archive/Anaconda2-4.2.0-Linux-x86_64.sh && \
    chmod a+rx Anaconda2-4.2.0-Linux-x86_64.sh

EXPOSE 8080

CMD ["python", "server.py"]
