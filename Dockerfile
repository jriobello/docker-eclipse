FROM nimmis/java-centos:openjdk-8-jdk
MAINTAINER LDEjieCAC@elkarlan.ejie.eus
RUN mkdir /eclipse && \
    chmod a+xr /eclipse && \
    useradd -b /eclipse -m -s /bin/bash developer
#COPY /neon /eclipse
#RUN yum install unzip
COPY /unzip  /usr/bin/
#RUN wget -e use_proxy=yes -e http_proxy=http://jriobell:Ej02082410@proxyejgv:8080 -e  https_proxy=http://jriobell:Ej02082410@proxyejgv:8080 -P /eclipse http://download.oracle.com/otn_software/oepe/12.2.1.5/neon/oepe-12.2.1.5-neon-distro-linux-gtk-x86_64.zip
#RUN unzip /eclipse/oepe-12.2.1.5-neon-distro-linux-gtk-x86_64.zip
RUN cd /eclipse & wget -e use_proxy=yes --no-check-certificate -P /eclipse -e http_proxy=http://jriobell:Ej02082410@proxyejgv:8080 -e https_proxy=http://jriobell:Ej02082410@proxyejgv:8080 https://the.earth.li/~sgtatham/putty/latest/w64/putty.zip
RUN unzip /eclipse/putty.zip
RUN mv /eclipse/eclipse /eclipse/neon
RUN chown developer:developer -R /eclipse
WORKDIR /eclipse
USER developer
RUN /eclipse/neon/eclipse
