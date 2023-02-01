FROM python

RUN apt-get update && apt-get upgrade -y

RUN apt-get install --no-install-recommends -y libfreetype6-dev libatlas-base-dev liblapack-dev gfortran && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir numpy
RUN pip install --no-cache-dir scipy
RUN pip install --no-cache-dir matplotlib
RUN pip install --no-cache-dir scikit-learn

RUN apt-get clean
