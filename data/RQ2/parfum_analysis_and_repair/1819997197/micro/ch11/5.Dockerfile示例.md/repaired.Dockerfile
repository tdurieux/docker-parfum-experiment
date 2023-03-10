# Dockerfile 定制镜像

镜像的定制实际上就是定制每一层所添加的配置、文件。如果我们可以把每一层修改、安装、构建、操作的命令都写入一个脚本，用这个脚本来构建、定制镜像，那么之前提及的无法重复的问题、镜像构建透明性的问题、体积的问题就都会解决。这个脚本就是 Dockerfile。

Dockerfile 是一个文本文件，其内包含了一条条的 指令(Instruction)，每一条指令构建一层，因此每一条指令的内容，就是描述该层应当如何构建。

## demo
1.建一个单独的目录docker-demo来存放示例所需要的文件
```
[root@will home]# mkdir -p docker-demo/html
[root@will home]# cd docker-demo/
[root@will docker-demo]# echo '<h1>Hello Docker!</h1>' > html/index.html
```

2.在当前目录(docker-demo)创建一个叫 Dockerfile 的新文件，包含下面的内容
```
FROM nginx
COPY html/* /usr/share/nginx/html
```

3.构建镜像
```
[root@will docker-demo]# docker build -t docker-demo:0.1 .
Sending build context to Docker daemon  3.584kB
Step 1/2 : FROM nginx
latest: Pulling from library/nginx
fc7181108d40: Pull complete
c4277fc40ec2: Pull complete
780053e98559: Pull complete
Digest: sha256:bdbf36b7f1f77ffe7bd2a32e59235dff6ecf131e3b6b5b96061c652f30685f3a
Status: Downloaded newer image for nginx:latest
 ---> 719cd2e3ed04
Step 2/2 : COPY html/* /usr/share/nginx/html
 ---> 7fe8ada8788a
Successfully built 7fe8ada8788a
Successfully tagged docker-demo:0.1
```

4.查看宿主机镜像
```
[root@will docker-demo]# docker image ls
REPOSITORY          TAG                 IMAGE ID            CREATED              SIZE
docker-demo         0.1                 7fe8ada8788a        About a minute ago   109MB
nginx               latest              719cd2e3ed04        37 hours ago         109MB
ubuntu              18.04               d131e0fa2585        6 weeks ago          102MB
ubuntu              latest              d131e0fa2585        6 weeks ago          102MB
hello-world         latest              fce289e99eb9        5 months ago         1.84kB
```

5.把刚刚构建的镜像运行起来。Nginx 默认监听在 80 端口，所以我们把宿主机的 8080 端口映射到容器的 80 端口
```
[root@will docker-demo]# docker run --name docker-demo -d -p 8080:80 docker-demo:0.1
a37fba8a51799e5e93b73792cc822a1baaacd65342852810df86d094e2a7711c
```

6.查看正在运行的容器
```
[root@will docker-demo]# docker container ls
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS                  NAMES
a37fba8a5179        docker-demo:0.1     "nginx -g 'daemon of…"   43 seconds ago      Up 42 seconds       0.0.0.0:8080->80/tcp   docker-demo
```

7.curl 访问 http://localhost:8080
```
[root@will docker-demo]# curl http://localhost:8080
<h1>Hello Docker!</h1>
```

## Dockerfile指令