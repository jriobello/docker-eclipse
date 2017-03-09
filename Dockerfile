FROM nimmis/java-centos:openjdk-8-jdk

MAINTAINER LDEjieCAC@elkarlan.ejie.eus

ENV proxyHost proxye
ENV proxyPort 8080
ENV proxyUser user
ENV proxyPassword pass
ENV ECLIPSE_ZIP_FILE "oepe-12.2.1.5-neon-distro-linux-gtk-x86_64.zip"
ENV ECLIPSE_NEON_ZIP_URL "http://download.oracle.com/otn_software/oepe/12.2.1.5/neon/${ECLIPSE_ZIP_FILE}"
#ENV PLUGIN_UDA_ZIP_URL "https://docs.google.com/uc?authuser=0&id=0B2jWuJHnBpz_UkZ0N3lxbDVKYkE&export=download"
ENV PLUGIN_UDA_ZIP_URL "https://docs.google.com/uc?id=0B2jWuJHnBpz_UkZ0N3lxbDVKYkE&export=download"
ENV PLUGIN_UDA_ZIP_FILE "pluginUDAInstall-v3.0.0.zip"

#Variables internas empiezan por _
ENV _proxyString "http://${proxyUser}:${proxyPassword}@${proxyHost}:${proxyPort}"
#Para yum tienen que ser estas
ENV http_proxy ${_proxyString}
ENV https_proxy ${_proxyString}

RUN yum -y install unzip && \
	yum -y install libgnomeui libxtst gtk && \
	yum clean all

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

#Plugin Subversive
ENV PLUGIN_SUBVERSIVE_ZIP_FILE "Subversive-4.0.2.I20160902-1700.zip"
ENV PLUGIN_SUBVERSIVE_ZIP_URL "http://ftp.fau.de/eclipse/technology/subversive/4.0/builds/neon/${PLUGIN_SUBVERSIVE_ZIP_FILE}"
WORKDIR /eclipse/developer
USER developer
RUN mkdir subversivePlugin && cd subversivePlugin && wget -O ${PLUGIN_SUBVERSIVE_ZIP_FILE} -e use_proxy=yes --no-check-certificate -e http_proxy=${_proxyString} -e https_proxy=${_proxyString} "${PLUGIN_SUBVERSIVE_ZIP_URL}" && \
        unzip ${PLUGIN_SUBVERSIVE_ZIP_FILE}  && \
        rm -f ${PLUGIN_SUBVERSIVE_ZIP_FILE}
WORKDIR /eclipse/developer
USER developer
RUN mv subversivePlugin/features/* features/ && mv  subversivePlugin/plugins/* plugins/

#Plugin de UDA
WORKDIR /eclipse/developer
USER developer
RUN wget -O ${PLUGIN_UDA_ZIP_FILE} -e use_proxy=yes --no-check-certificate -e http_proxy=${_proxyString} -e https_proxy=${_proxyString} "${PLUGIN_UDA_ZIP_URL}" && \
	unzip ${PLUGIN_UDA_ZIP_FILE}  && \
	rm -f ${PLUGIN_UDA_ZIP_FILE}
WORKDIR /eclipse/developer
USER developer
RUN mv pluginUDAInstall-v3.0.0/features/* features/ && mv  pluginUDAInstall-v3.0.0/plugins/* plugins/ && rm -rf pluginUDAInstall-v3.0.0
#Templates
ENV PLUGIN_UDA_T_ZIP_URL "https://docs.google.com/uc?id=0B2jWuJHnBpz_TmlxTUw5bndBMW8&export=download"
ENV PLUGIN_UDA_T_ZIP_FILE "templates-v3.0.0.zip"
WORKDIR /eclipse/developer
USER developer
RUN wget -O ${PLUGIN_UDA_T_ZIP_FILE} -e use_proxy=yes --no-check-certificate -e http_proxy=${_proxyString} -e https_proxy=${_proxyString} "${PLUGIN_UDA_T_ZIP_URL}" && \
        unzip ${PLUGIN_UDA_T_ZIP_FILE}  && \
        rm -f ${PLUGIN_UDA_T_ZIP_FILE}
WORKDIR /eclipse/developer
USER developer
RUN mv templates tmpTemplates && mv tmpTemplates/templates . && rm -rf tmpTemplates
#JBoss hibernate tools
ENV HIBERNATE_TOOLS_ZIP_FILE "jbosstools-4.4.3.Final-updatesite-core.zip"
ENV HIBERNATE_TOOLS_ZIP_URL "http://download.jboss.org/jbosstools/static/neon/development/updates/core/${HIBERNATE_TOOLS_ZIP_FILE}"
WORKDIR /eclipse/developer
USER developer
RUN mkdir tmpJBoss && cd tmpJBoss && wget -O ${HIBERNATE_TOOLS_ZIP_FILE} -e use_proxy=yes --no-check-certificate -e http_proxy=${_proxyString} -e https_proxy=${_proxyString} "${HIBERNATE_TOOLS_ZIP_URL}" && \
        unzip ${HIBERNATE_TOOLS_ZIP_FILE}  && \
        rm -f ${HIBERNATE_TOOLS_ZIP_FILE}
WORKDIR /eclipse/developer
USER developer
RUN mv tmpJBoss/plugins/* plugins/ &&  mv tmpJBoss/features/* features/ && rm -rf tmpJBoss

#Copiar ojdbc.jar  a jar de hibernate...
#WORKDIR /eclipse/developer
#USER developer
#RUN mkdir -p tmpJboss && cp "plugins/oracle.database.driver.11_16.3.0.201612160743/ojdbc6.jar" tmpUDA/lib && jar uvf plugins/org.jboss.tools.hibernate.runtime.v_3_5_5.1.2.v20161116-1036.jar tmpUDA/  && rm -rf tmpUDA

WORKDIR /eclipse/developer
USER developer
CMD /eclipse/developer/eclipse -configuration /eclipse/developer/config
