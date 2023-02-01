FROM molab/spark-yarn

RUN apt-get install --no-install-recommends -y build-essential python-dev python-pip && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir jupyter

COPY jupyter_notebook_config.py /root/.jupyter/jupyter_notebook_config.py

RUN mkdir /data/notebooks

COPY start.sh /start.sh
RUN chmod +x /start.sh

EXPOSE 8888

ENTRYPOINT [ "/start.sh" ]
