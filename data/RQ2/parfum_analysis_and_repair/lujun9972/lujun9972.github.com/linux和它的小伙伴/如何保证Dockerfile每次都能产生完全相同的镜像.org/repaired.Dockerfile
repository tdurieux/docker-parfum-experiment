#+TITLE: 如何保证Dockerfile每次都能产生完全相同的镜像
#+AUTHOR: lujun9972
#+TAGS: linux和它的小伙伴,docker
#+DATE: [2018-08-18 六 15:39]
#+LANGUAGE:  zh-CN
#+OPTIONS:  H:6 num:nil toc:t \n:nil ::t |:t ^:nil -:nil f:t *:t <:nil

摘录自 《Docker开发指南》 13.6.3 "可复制及可信任的Dockerfile"

* FROM指令中使用标签或摘要以保证每次下载的镜像完全相同

若FROM指令不带标签，则Docker默认下载 =latest= 标签的镜像，而该镜像很容易随着时间的变化而变化。

一个好方法是明确指定镜像的标签，但即使是同一个标签也可能会出现一些小更新，若想要保证镜像完全一致，则需要指定下载镜像的摘要。
#+BEGIN_SRC shell
  FROM redis@sha256:xxxxxxxxxxxxxxxxxxxxxxxxxxxxx...
#+END_SRC

* 使用包管理器安装软件时指定版本号

跟上一条类似，使用包管理器安装软件默认安装的是最新版的软件，但有可能随着时间的推移而发生改变。

#+BEGIN_SRC shell
  apt-get install cowsay=3.03+dfsg1-6
#+END_SRC