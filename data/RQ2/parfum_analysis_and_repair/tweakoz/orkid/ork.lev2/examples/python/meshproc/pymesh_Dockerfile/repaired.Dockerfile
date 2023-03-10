FROM pymesh/pymesh:latest
ARG PORT
ENV PORT=$PORT
USER root
RUN pip3 install --no-cache-dir zmq
RUN mkdir -p /project
WORKDIR /project
ADD data/nub1.obj nub1.obj
ADD meshproc_server.py meshproc_server.py
RUN chmod go+rwx meshproc_server.py
#CMD bash
CMD ./meshproc_server.py
