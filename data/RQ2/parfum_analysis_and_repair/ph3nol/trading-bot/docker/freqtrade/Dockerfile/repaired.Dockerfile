FROM freqtradeorg/freqtrade:stable

RUN pip install --no-cache-dir --upgrade pip

RUN pip install --no-cache-dir -U -r requirements-plot.txt
RUN pip install --no-cache-dir technical
RUN pip install --no-cache-dir ta
RUN pip install --no-cache-dir finta
