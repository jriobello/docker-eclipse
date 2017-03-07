FROM nimmis/java-centos:openjdk-8-jdk

MAINTAINER LDEjieCAC@elkarlan.ejie.eus

ENV proxyHost changeme
ENV proxyPort 8080
ENV proxyUser jriobell
ENV proxyPassword *****
ENV ECLIPSE_ZIP_FILE "oepe-12.2.1.5-neon-distro-linux-gtk-x86_64.zip"
ENV ECLIPSE_NEON_ZIP_URL "http://download.oracle.com/otn_software/oepe/12.2.1.5/neon/${ECLIPSE_ZIP_FILE}"
#ENV ECLIPSE_ZIP_FILE "putty.zip"
#ENV ECLIPSE_NEON_ZIP_URL "https://the.earth.li/~sgtatham/putty/latest/w64/${ECLIPSE_ZIP_FILE}"

#Variables internas empiezan por _
ENV _proxyString "http://${proxyUser}:${proxyPassword}@${proxyHost}:${proxyPort}"
#Para yum tienen que ser estas
ENV http_proxy ${_proxyString}
ENV https_proxy ${_proxyString}

RUN mkdir /eclipse && \
    chmod a+xr /eclipse && \
    useradd -b /eclipse -m -s /bin/bash developer
RUN yum -y install unzip
RUN cd /eclipse & wget -e use_proxy=yes --no-check-certificate -P /eclipse -e http_proxy=${_proxyString} -e https_proxy=${_proxyString} ${ECLIPSE_NEON_ZIP_URL}
RUN unzip /eclipse/${ECLIPSE_ZIP_FILE} & rm -f /eclipse/${ECLIPSE_ZIP_FILE}
RUN chown developer:developer -R /eclipse
WORKDIR /eclipse
USER developer
RUN /eclipse/eclipse
