FROM nimmis/java-centos:openjdk-8-jdk

MAINTAINER LDEjieCAC@elkarlan.ejie.eus

ENV proxyHost proxy
ENV proxyPort 8080
ENV proxyUser user
ENV proxyPassword passwd

#Variables internas empiezan por _
ENV _proxyString "http://${proxyUser}:${proxyPassword}@${proxyHost}:${proxyPort}"
#Para yum tienen que ser estas
ENV http_proxy ${_proxyString}
ENV https_proxy ${_proxyString}

RUN yum -y install unzip && \
	yum -y install libgnomeui libxtst gtk libwebkit3 && \
	yum clean all

ENV _proxyString ""
ENV proxyHost ""
ENV proxyPort ""
ENV proxyUser ""
ENV proxyPassword ""

RUN mkdir /eclipse && \
    chmod a+xr /eclipse && \
    useradd -b /eclipse -m -s /bin/bash udadev
RUN chown udadev:udadev /eclipse/udadev

#Es importante borrar en la misma linea para no hacer pesadas las imagenes
#WORKDIR /eclipse/udadev
#USER udadev
COPY oepe-12.2.1.5-neon-distro-linux-gtk-x86_64.zip /eclipse/udadev

WORKDIR /eclipse/udadev
USER udadev
RUN unzip oepe-12.2.1.5-neon-distro-linux-gtk-x86_64.zip && \
	rm -f oepe-12.2.1.5-neon-distro-linux-gtk-x86_64.zip


WORKDIR /eclipse/udadev
USER udadev
CMD ./eclipse -configuration /eclipse/udadev/config

#Una vez arrancado, he instalado desde el Market jboss tools y subversive. Despues, desactivado de arranque 
# el market y muchas opciones de jboss, e instaladao desde local el plugin de UDA.
# Finalmente, es necesario hacer un export e import para no tener las variables ENV...
# Buscar con docker ps el contenedor y crear la imagen a partir de el:
#	docker export 4aebbd730e7f |  docker import - jriobello/eclipse:uda 
