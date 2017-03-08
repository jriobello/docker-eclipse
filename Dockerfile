FROM nimmis/java-centos:openjdk-8-jdk

MAINTAINER LDEjieCAC@elkarlan.ejie.eus

ENV proxyHost proxy
ENV proxyPort 8080
ENV proxyUser user
ENV proxyPassword password
ENV ECLIPSE_ZIP_FILE "oepe-12.2.1.5-neon-distro-linux-gtk-x86_64.zip"
ENV ECLIPSE_NEON_ZIP_URL "http://download.oracle.com/otn_software/oepe/12.2.1.5/neon/${ECLIPSE_ZIP_FILE}"

#Variables internas empiezan por _
ENV _proxyString "http://${proxyUser}:${proxyPassword}@${proxyHost}:${proxyPort}"
#Para yum tienen que ser estas
ENV http_proxy ${_proxyString}
ENV https_proxy ${_proxyString}

RUN yum -y install unzip
RUN yum -y install libgnomeui libxtst gtk

RUN mkdir /eclipse && \
    chmod a+xr /eclipse && \
    useradd -b /eclipse -m -s /bin/bash developer
RUN chown developer:developer /eclipse/developer

#Es importante borrar en la misma linea para no hacer pesadas las imagenes
WORKDIR /eclipse/developer
USER developer
RUN wget -e use_proxy=yes --no-check-certificate -e http_proxy=${_proxyString} -e https_proxy=${_proxyString} ${ECLIPSE_NEON_ZIP_URL} && \
	unzip ${ECLIPSE_ZIP_FILE} && \
	rm -f ${ECLIPSE_ZIP_FILE}

WORKDIR /eclipse/developer
USER developer
CMD /eclipse/developer/eclipse -configuration /eclipse/developer/config
