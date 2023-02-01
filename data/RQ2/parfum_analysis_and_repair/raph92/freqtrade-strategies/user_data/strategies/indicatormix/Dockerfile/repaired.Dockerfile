FROM freqtradeorg/freqtrade
# install TA libs
RUN pip install --no-cache-dir ta finta pandas_ta scikit-optimize
