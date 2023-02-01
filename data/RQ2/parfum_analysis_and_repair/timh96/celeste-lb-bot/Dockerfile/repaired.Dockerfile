FROM python:3
# install dependencies
ADD requirements.txt /
RUN pip install --no-cache-dir -r requirements.txt
# add code
ADD __main__.py /
ADD celeste_bot.py /
ADD data_models.py /
ADD src_constants.py /
# run
CMD ["python", "-u", "./__main__.py", "--credentials", "./data/credentials.json", "--timer", "180"]