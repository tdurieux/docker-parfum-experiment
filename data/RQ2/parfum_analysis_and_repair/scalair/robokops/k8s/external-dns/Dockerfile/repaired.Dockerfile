FROM scalair/robokops-base:0.6.6
COPY src /home/builder/src
RUN sudo chown -R builder:builder /home/builder
RUN echo 'external-dns' | sudo tee /name
VOLUME /conf