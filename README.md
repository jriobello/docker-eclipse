# docker-eclipse
My eclipse Docker was created to run eclispe in docker...

Uso VirtualBox para crear una máquina con Fedora24.

La configuro para que docker pueda salir con proxy a dockerHub:
/etc/systemd/system/docker.service.d/http-proxy.conf:
    [Service]
    Environment="HTTPS_PROXY=http://user:password@myProxyHost:myProxyPort/"

systemctl daemon-reload

y confiar en el certificado de mi red corporativa añadiendo el crt de mi proxy ssl a la ruta /etc/pki/ca-trust/source/anchors y lanzado update-ca-certificates

Creo después Dockerfile y lanzo:
    docker build -f Dockerfile -t jriobello/eclipse:neon .
...
Ver https://hub.docker.com/r/jriobello/eclipse/
