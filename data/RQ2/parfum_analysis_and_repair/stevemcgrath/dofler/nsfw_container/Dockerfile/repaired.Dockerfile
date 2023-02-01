FROM bvlc/caffe:cpu

COPY nsfw /opt/nsfw/
RUN mkdir /images
RUN pip install --no-cache-dir -r /opt/nsfw/requirements.txt

EXPOSE 8080

CMD python /opt/nsfw/nsfw.py