FROM point-os
VOLUME ["/home/point/xmpp"]
WORKDIR /home/point/xmpp
CMD ["python", "run.py"]