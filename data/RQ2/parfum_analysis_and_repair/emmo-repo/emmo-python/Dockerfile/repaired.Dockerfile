from continuumio/miniconda3
RUN apt update && apt install --no-install-recommends -y texlive-latex-extra texlive-xetex graphviz && rm -rf /var/lib/apt/lists/*;
RUN wget https://github.com/jgm/pandoc/releases/download/2.1.2/pandoc-2.1.2-1-amd64.deb && apt install --no-install-recommends -y ./pandoc-2.1.2-1-amd64.deb && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir --upgrade pip

RUN useradd -ms /bin/bash user
COPY . /home/user/EMMO-python
RUN cd /home/user/EMMO-python && pip install --no-cache-dir -e . && cd -
RUN chown user:user -R /home/user/EMMO-python/
USER user
WORKDIR /home/user/
#ENTRYPOINT python
