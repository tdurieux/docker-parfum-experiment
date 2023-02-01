FROM pytorch/pytorch:latest
ARG  pypi="https://pypi.org/simple"
ENV  pypi=$pypi
# system install
USER root
COPY . /app
RUN pip install --no-cache-dir --upgrade pip -q
RUN pip install --no-cache-dir -f /app/packages -i $pypi --extra-index-url https://pypi.org/simple/ --pre omegaml[hdf,graph,dashserve,sql,iotools,streaming] jupyterhub jupyterlab
RUN /app/scripts/setupnb.sh

