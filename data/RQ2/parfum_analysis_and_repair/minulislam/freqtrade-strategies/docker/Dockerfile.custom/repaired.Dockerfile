FROM freqtradeorg/freqtrade:develop_plot

# Switch user to root if you must install something from apt
# Don't forget to switch the user back below!
# USER root

RUN pip install --user ta --no-cache-dir
RUN pip install --user finta --no-cache-dir
RUN pip install --user pandas-ta --no-cache-dir

# USER ftuser