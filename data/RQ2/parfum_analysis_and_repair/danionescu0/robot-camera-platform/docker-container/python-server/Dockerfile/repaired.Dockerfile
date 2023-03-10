FROM generalaardvark/rpi-python35

RUN apt-get update && apt-get install --no-install-recommends -y git ca-certificates && rm -rf /var/lib/apt/lists/*;

WORKDIR /root
RUN git clone https://github.com/danionescu0/robot-camera-platform.git
RUN pip install --no-cache-dir -qr /root/robot-camera-platform/requirements_robot_camera.txt

#for debugging purposes the server runs from the mounted volume /root/debug
#the volume is mounted in docker-compose.yml and it assumes the project is clonned inside /home/pi/robot-camera-platform

CMD ["python", "/root/debug/server.py"]