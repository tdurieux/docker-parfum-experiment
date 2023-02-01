FROM ubuntu

# get up pip, vim, etc.
RUN apt-get -y update --fix-missing
RUN apt-get install --no-install-recommends -y python-pip python-dev libev4 libev-dev gcc libxslt-dev libxml2-dev libffi-dev vim curl && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir --upgrade pip

# get numpy, scipy, scikit-learn and flask
RUN apt-get install --no-install-recommends -y python-numpy python-scipy python-matplotlib && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir pandas

# add our project
ADD analyze.py /analyze.py
