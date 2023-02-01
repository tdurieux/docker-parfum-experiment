FROM python

RUN apt-get update && apt-get upgrade -y

RUN pip install --no-cache-dir --upgrade pip

RUN pip install --no-cache-dir keras
RUN pip install --no-cache-dir scikit-learn

RUN apt-get clean
