FROM zenmldocker/zenml:0.8.1

WORKDIR /app

RUN pip3 install --no-cache-dir pandas-gbq scikit-learn

COPY . .

