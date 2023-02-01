FROM qa-base_rust2:1.0
#FROM daocloud.io/quantaxis/qabase:latest
COPY jupyterlab_language_pack_zh_CN-0.0.1.dev0-py2.py3-none-any.whl /root/QUANTAXIS/home/jupyterlab_language_pack_zh_CN-0.0.1.dev0-py2.py3-none-any.whl
COPY entrypoint.sh /entrypoint.sh
COPY jupyter_notebook_config.py /root/.jupyter/

WORKDIR home
RUN apt update && apt install --no-install-recommends make build-essential -y && rm -rf /var/lib/apt/lists/*;
RUN git clone https://gitee.com/yutiansut/ta-lib \
	&& cd ta-lib && chmod +x ./*\
 && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix=/usr \
	&& make \
	&& make install \
  && cd .. \
	&& rm -rf ta-lib \
  && pip install --no-cache-dir tornado==6.1.0 jupyterlab-kite -i https://pypi.doubanio.com/simple\
  && pip install jupyterlab_language_pack_zh_CN-0. && pip install --no-cache-dir jupyterlab_language_pack_zh_CN-0.0.1.dev0-py2.py3-none-any.whl \
  && pip install --no-cache-dir xlrd peakutils quantaxis-servicedetect prompt-toolkit -i https://pypi.doubanio.com/simple\
  && pip install quantaxis -U \ && pip install --no-cache-dir quantaxis -U \
  && pip uninstall pytdx -y \
  && pip install --no-cache-dir pytdx -i https://pypi.doubanio.com/simple\
  && pip install pandaral && pip install --no-cache-dir pandarallel qgrid redis aioch quantaxis-pubsub dag-factory apscheduler -i https://pypi.doubanio.com/simple\
  && jupyter nbextension enable --py widgetsnbextension \ && jupyter nbextension enable --py widgetsnbextension \
  && jupyter serverextension enable --py jupyterlab

RUN apt update

RUN apt install --no-install-recommends -y curl\
 && apt install --no-install-recommends npm -y \
&& npm install npm -g \
&& npm install n -g && npm cache clean --force; && rm -rf /var/lib/apt/lists/*;
RUN n stable


# RUN jupyter nbextension enable --py --sys-prefix qgrid\
# && jupyter nbextension enable --py --sys-prefix widgetsnbextension\
# && jupyter labextension install @jupyter-widgets/jupyterlab-manager\
# && jupyter labextension install qgrid


RUN chmod +x /entrypoint.sh
EXPOSE 8888

COPY runpy.sh /root/
RUN chmod +x /opt/conda/lib/python3.8/site-packages/QUANTAXIS/QAUtil/QASetting.py

RUN chmod +x /root/runpy.sh
CMD ["bash", "/root/runpy.sh"]
