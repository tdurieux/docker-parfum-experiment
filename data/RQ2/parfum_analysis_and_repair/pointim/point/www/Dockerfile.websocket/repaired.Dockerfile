FROM point-os
VOLUME ["/home/point/www"]
WORKDIR /home/point/www
EXPOSE 8089
CMD ["python", "websocket.py"]