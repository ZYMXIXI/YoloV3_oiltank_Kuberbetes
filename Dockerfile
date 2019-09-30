#导入环境
FROM centos:latest
MAINTAINER Zhangym "zhangym@geovis.com.cn"

#安装程序依赖需要的所有库
#安装python

RUN set -ex \
    && yum install -y wget tar libffi-devel zlib-devel bzip2-devel openssl-devel ncurses-devel sqlite-devel readline-devel tk-devel gcc make initscripts \
    && wget https://www.python.org/ftp/python/3.6.8/Python-3.6.8.tgz \
    && tar -zxvf Python-3.6.8.tgz \
    && cd Python-3.6.8 \
    && ./configure prefix=/usr/local/python3 \
    && make \
    && make install \
    && make clean \
    && cd .. \
    && rm -rf /Python-3.6.8* \
    && yum install -y epel-release \
    && yum install -y python-pip

RUN set -ex \
 # 备份旧版本python
     && mv /usr/bin/python /usr/bin/python27 \
     && mv /usr/bin/pip /usr/bin/pip-python2.7 \
     # 配置默认为python3
     && ln -s /usr/local/python3/bin/pip3 /usr/bin/pip \
     && pip install scipy -i http://pypi.douban.com/simple/ --trusted-host pypi.douban.com \
 #如果要用到scipy这个包，就需要用python2.7安装，python3.5安装会失败
     && ln -s /usr/local/python3/bin/python3.6 /usr/bin/python
 
 ##修复python版本改变，yum问题
RUN set -ex \
     && sed -i "s#/usr/bin/python#/usr/bin/python2.7#" /usr/bin/yum \
     && sed -i "s#/usr/bin/python#/usr/bin/python2.7#" /usr/libexec/urlgrabber-ext-down \
     && yum install -y deltarpm

##配置清华源
RUN pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple
 
#
RUN python -V 
#RUN yum -y install python-devel scipy


##查看是否安装版本
#RUN python -V

##安装依赖库
ENV CODE_DIR=/YOLO
RUN mkdir -p $CODE_DIR/yolov3_oiltank/
COPY ./YOLO $CODE_DIR/yolov3_oiltank/



RUN python -V
 
RUN python -m pip install --upgrade pip
#RUN pip install --upgrade setuptools
RUN pip install keras tensorflow-gpu opencv-python -i http://pypi.douban.com/simple/ --trusted-host pypi.douban.com
RUN pip install -r $CODE_DIR/yolov3_oiltank/requirements.txt 


#ADD ./YOLO /data/yolov3_oiltank/

#CMD执行命令
COPY ./start.sh /usr/bin/my-start.sh
RUN chmod +x /usr/bin/my-start.sh
CMD ["my-start.sh"]
#RUN /usr/bin/my-start.sh  



