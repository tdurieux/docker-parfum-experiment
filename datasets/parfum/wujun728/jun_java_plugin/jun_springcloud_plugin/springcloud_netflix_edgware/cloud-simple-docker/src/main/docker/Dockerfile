# �����Ǹ�����
FROM daocloud.io/java:8
# �������ļ��й��ص���ǰ������tomcatʹ�ã�
VOLUME /tmp
# �����ļ�������
ADD cloud-simple-docker-1.0.0.jar /app.jar
# �򿪷���˿�
EXPOSE 8080
# ��������������ִ�е�����
RUN bash -c 'touch /app.jar'
ENTRYPOINT ["java","-Djava.security.egd=file:/dev/./urandom","-jar","/app.jar"]