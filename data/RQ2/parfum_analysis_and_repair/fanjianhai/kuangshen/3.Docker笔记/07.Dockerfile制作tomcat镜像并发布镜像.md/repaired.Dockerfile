## Dockerfile����tomcat����

1. ׼�������ļ� tomcatѹ������jdk��ѹ������

![���������ͼƬ����](https://img-blog.csdnimg.cn/20200813164403261.png#pic_center)

2. ��дDockerfile�ļ����ٷ�����`Dockerfile`, build���Զ�Ѱ������ļ����Ͳ���Ҫ-fָ���ˣ�

```shell
[root@iZ2zeg4ytp0whqtmxbsqiiZ tomcat]# cat Dockerfile
FROM centos
MAINTAINER xiaofan<594042358@qq.com>

COPY readme.txt /usr/local/readme.txt

ADD jdk-8u73-linux-x64.tar.gz /usr/local/
ADD apache-tomcat-9.0.37.tar.gz /usr/local/

RUN yum -y install vim && rm -rf /var/cache/yum

ENV MYPATH /usr/local
WORKDIR $MYPATH

ENV JAVA_HOME /usr/local/jdk1.8.0_73
ENV CLASSPATH $JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar
ENV CATALINA_HOME /usr/local/apache-tomcat-9.0.37
ENV CATALINA_BASH /usr/local/apache-tomcat-9.0.37
ENV PATH $PATH:$JAVA_HOME/bin:$CATALINA_HOME/lib:$CATALINA_HOME/bin

EXPOSE 8080

CMD /usr/local/apache-tomcat-9.0.37/bin/startup.sh && tail -F /usr/local/apache-tomcat-9.0.37/bin/logs/catalina.out

```

3. ��������

```shell
# docker build -t diytomcat .
```

4. ��������

```shell
#  docker run -d -p 3344:8080 --name xiaofantomcat1 -v /home/xiaofan/build/tomcat/test:/usr/local/apache-tomcat-9.0.37/webapps/test -v /home/xiaofan/build/tomcat/tomcatlogs/:/usr/local/apache-tomcat-9.0.37/logs diytomcat
```

5. ���ʲ���

6. ������Ŀ���������˾����أ� ����ֱ���ڱ��ر�д��Ŀ�Ϳ��Է����ˣ�

**�ڱ��ر�дweb.xml��index.jsp���в���**

![���������ͼƬ����](https://img-blog.csdnimg.cn/20200813180242294.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2ZhbmppYW5oYWk=,size_16,color_FFFFFF,t_70#pic_center)

```shell
<?xml version="1.0" encoding="UTF-8"?>
<web-app version="2.4"
    xmlns="http://java.sun.com/xml/ns/j2ee"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xsi:schemaLocation="http://java.sun.com/xml/ns/j2ee
        http://java.sun.com/xml/ns/j2ee/web-app_2_4.xsd">

</web-app>
```

```shell
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>hello. xiaofan</title>
</head>
<body>
Hello World!<br/>
<%
System.out.println("-----my test web logs------");
%>
</body>
</html>
```

���֣���Ŀ����ɹ��� ����ֱ�ӷ���ok��

�����Ժ󿪷��Ĳ��裺��Ҫ����Dockerfile�ı�д�� ����֮���һ�ж���ʹ��docker�������������еģ�

![���������ͼƬ����](https://img-blog.csdnimg.cn/20200813175909845.png#pic_center)

## �����Լ��ľ���Docker Hub

>  Docker Hub

1. [��ַ](https://hub.docker.com/) ע���Լ����˺ţ�

   ![���������ͼƬ����](https://img-blog.csdnimg.cn/20200813182851607.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2ZhbmppYW5oYWk=,size_16,color_FFFFFF,t_70#pic_center)

2. ȷ������˺ſ��Ե�¼

![���������ͼƬ����](https://img-blog.csdnimg.cn/20200813183151439.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2ZhbmppYW5oYWk=,size_16,color_FFFFFF,t_70#pic_center)



3. �����ǵķ��������ύ�Լ��ľ���

```shell
# push�����ǵķ�������
[root@iZ2zeg4ytp0whqtmxbsqiiZ ~]# docker push diytomcat
The push refers to repository [docker.io/library/diytomcat]
2eaca873a720: Preparing
1b38cc4085a8: Preparing
088ebb58d264: Preparing
c06785a2723d: Preparing
291f6e44771a: Preparing
denied: requested access to the resource is denied	# �ܾ�

# push��������⣿
The push refers to repository [docker.io/1314520007/diytomcat]
An image does not exist locally with the tag: 1314520007/diytomcat

# ���������һ��tag
docker tag diytomcat 1314520007/tomcat:1.0
```

![���������ͼƬ����](https://img-blog.csdnimg.cn/20200813184137474.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2ZhbmppYW5oYWk=,size_16,color_FFFFFF,t_70#pic_center)



## �����������ƾ��������

1. ��¼������
2. �ҵ������������
3. ���������ռ�

![���������ͼƬ����](https://img-blog.csdnimg.cn/20200813190111625.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2ZhbmppYW5oYWk=,size_16,color_FFFFFF,t_70#pic_center)

4. ������������

![���������ͼƬ����](https://img-blog.csdnimg.cn/20200813190303741.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2ZhbmppYW5oYWk=,size_16,color_FFFFFF,t_70#pic_center)

5. ����ֿ����ƣ��ο��ٷ��ĵ�����

![���������ͼƬ����](https://img-blog.csdnimg.cn/20200813191526549.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2ZhbmppYW5oYWk=,size_16,color_FFFFFF,t_70#pic_center)

## �ܽ�

![���������ͼƬ����](https://img-blog.csdnimg.cn/20200813194116511.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2ZhbmppYW5oYWk=,size_16,color_FFFFFF,t_70#pic_center)

![���������ͼƬ����](https://img-blog.csdnimg.cn/2020081319424581.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2ZhbmppYW5oYWk=,size_16,color_FFFFFF,t_70#pic_center)