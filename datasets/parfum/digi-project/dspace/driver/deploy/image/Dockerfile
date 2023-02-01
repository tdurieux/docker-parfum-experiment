FROM python:3.7
WORKDIR /src/

# uncomment to use dist
RUN pip install digi
RUN git clone https://github.com/silveryfu/kopf.git
RUN cd kopf; git checkout low-lat; pip install -e .

COPY . .
RUN (ls thirdparty.txt >> /dev/null 2>&1 && pip install -r thirdparty.txt) || true
# comment out to use dist
#RUN (cd driver; pip install -e .)

CMD python3 handler.py
