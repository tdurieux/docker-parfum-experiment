FROM jupyter/minimal-notebook

EXPOSE 8888

# Install Python packages
USER root
COPY . /tmp/code
RUN python3 -m pip install --upgrade pip
RUN pip3 install --no-cache-dir /tmp/code
USER ${NB_UID}

CMD ["jupyter", "notebook", "--no-browser", "--ip", "0.0.0.0", "--port=8888"]
