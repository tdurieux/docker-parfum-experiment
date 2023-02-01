FROM python:3.8

RUN mkdir /docs

ADD ./Makefile /docs/Makefile
ADD ./requirements.txt /docs/requirements.txt

RUN apt-get update && apt-get install --no-install-recommends -y -q sphinx-doc sphinx-common texlive texlive-latex-extra pandoc build-essential && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir -r /docs/requirements.txt

WORKDIR /docs

CMD ["/bin/bash"]
