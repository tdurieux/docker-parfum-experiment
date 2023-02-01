FROM python

RUN mkdir git
WORKDIR /git
RUN git clone https://github.com/jmoss20/notears.git
WORKDIR /git/notears

RUN pip install --no-cache-dir -r requirements.txt
RUN pip install --no-cache-dir matplotlib pandas
ENV PYTHONPATH /git:/git/notears
RUN apt update && apt install -y --no-install-recommends time && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir contextlib2
CMD bash
