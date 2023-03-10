COPY entrypoint.sh .
COPY CMakeLists.txt .
COPY package.xml .
COPY agents/${AGENT}/src ./src
COPY helpers/* ./src/

RUN /bin/bash -c "source /opt/ros/noetic/setup.bash; cd /ws; catkin build"
RUN chmod a+x src/* && chmod +x entrypoint.sh

ARG MODEL
COPY ${MODEL} src/.

WORKDIR /ws

EXPOSE 11311
ENTRYPOINT ["/ws/src/f1tenth_agent_ros/entrypoint.sh"]

CMD ["/bin/bash", "-c", "python3 ./src/f1tenth_agent_ros/src/agent.py"]