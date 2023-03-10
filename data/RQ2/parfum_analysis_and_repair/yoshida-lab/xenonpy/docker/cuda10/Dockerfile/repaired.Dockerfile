FROM yoshidalab/base:cuda10

# install xenonpy locally
WORKDIR /opt/xenonpy
COPY . .
RUN sudo chown -R user:user /opt && find . | grep -E "(__pycache__|\.pyc|\.pyo$)" | xargs rm -rf && \
    pip install --no-cache-dir --user -v .

EXPOSE 8888

WORKDIR /workspace
CMD [ "jupyter" , "lab", "--ip=0.0.0.0", "--no-browser", "--port=8888", "--allow-root"]