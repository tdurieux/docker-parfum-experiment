From r-base:3.6.1
RUN apt-get update -y && apt-get install --no-install-recommends -y -f python3 python-dev python3-pip && rm -rf /var/lib/apt/lists/*;
ADD src/ /src
ADD tests/ /tests
RUN pip3 install --no-cache-dir pytest 'numpy~=1.16' 'scipy~=1.2' 'matplotlib~=3.0' 'pillow~=6.0' 'statsmodels~=0.9' 'rpy2'
RUN R -e "install.packages('MASS')"
RUN R -e "install.packages('pscl')"

CMD [ "pytest", "./tests" ]

