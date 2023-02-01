Dockerfile 语法
===============

`官方文档 <https://docs.docker.com/engine/reference/builder/>`__

一个简单的例子：

.. code:: shell

    # Print "Hello docker!"
    RUN echo "Hello docker!"

FROM
----

第一条指令必须为 FROM 指令,用来指定使用的镜像，#号开头的为注释。

::

    FROM centos:6

MAINTAINER(deprecated)
----------------------

`MAINTAINER
(deprecated) <https://docs.docker.com/engine/reference/builder/#maintainer-deprecated>`__

推荐使用LABEL

指定维护者信息。

::

    MAINTAINER  yy

LABEL
-----

LABEL maintainer=“SvenDowideit@home.org.au”

RUN
---

RUN 指令对镜像执行跟随的命令。

::

    RUN echo "yy" > /opt/author

CMD
---

和RUN命令相似，CMD可以用于执行特定的命令。和RUN不同的是，这些命令不是在镜像构建的过程中执行的，而是在用镜像构建容器后被调用。

.. code:: shell

    # Usage 1: CMD application "argument", "argument", ..
    CMD "echo" "Hello docker!"

支持三种格式

-  CMD [“executable”,”param1″,”param2″] 使用 exec 执行，推荐方式；
-  CMD command param1 param2 在 /bin/sh 中执行，提供给需要交互的应用；
-  CMD [“param1″,”param2”] 提供给 ENTRYPOINT 的默认参数；

ENTRYPOINT
----------

配置容器启动后执行的命令，并且不可被 ``docker run`` 提供的参数覆盖。

每个 Dockerfile 中只能有一个 ``ENTRYPOINT``,
当指定多个时，只有最后一个起效。

ENTRYPOINT
帮助你配置一个容器使之可执行化，如果你结合CMD命令和ENTRYPOINT命令，你可以从CMD命令中移除“application”而仅仅保留参数，参数将传递给ENTRYPOINT命令。

.. code:: shell

    # Usage: ENTRYPOINT application "argument", "argument", ..
    # Remember: arguments are optional. They can be provided by CMD
    # or during the creation of a container.
    ENTRYPOINT echo
    # Usage example with CMD:
    # Arguments set with CMD can be overridden during *run*
    CMD "Hello docker!"
    ENTRYPOINT echo

VOLUME
------

VOLUME命令用于让你的容器访问宿主机上的目录。

::

    VOLUME ["/my_files"]

EXPOSE
------

EXPOSE用来指定端口，使容器内的应用可以通过端口和外界交互。

::

    EXPOSE 80

ENV
---

用来设置环境变量

::

    ENV LANG en_US.UTF-8

    ENV PATH /usr/local/postgres-$PG_MAJOR/bin:$PATH

WORKDIR
-------

相当于CD命令，指定之后的RUN命令的运行目录

::

    WORKDIR /a

    WORKDIR b

    WORKDIR c

    RUN pwd

ADD
---

将源文件拷贝到容器对应的路径

::

    ADD <src> <dest>

可以是Dockerfile所在目录的一个相对路径,也可以是一个 URL；还可以是一个
tar 文件（自动解压为目录）。
