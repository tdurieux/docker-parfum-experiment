FROM python
RUN pip install --no-cache-dir pip --upgrade
ADD ./ ./
WORKDIR ./
RUN pip install --no-cache-dir -r ./requirements.txt
EXPOSE 80
CMD ["gunicorn", "app:app", "-b", "0.0.0.0:80", "-w", "4"]
