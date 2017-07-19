FROM jodogne/orthanc:1.3.0

MAINTAINER Sebastien Jodogne <s.jodogne@gmail.com>
LABEL Description="Official plugins for Orthanc" Vendor="Sebastien Jodogne, University Hospital of Liege"

RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install libgdcm2-dev libjpeg-dev postgresql-server-dev-all libtiff-dev libopenjpeg-dev libopenslide-dev && rm -rf /var/lib/apt/lists/*

ADD ./build-webviewer.sh /root/build-webviewer.sh
RUN bash /root/build-webviewer.sh "OrthancWebViewer-2.2"

ADD ./build-postgresql.sh /root/build-postgresql.sh
RUN bash /root/build-postgresql.sh "OrthancPostgreSQL-2.0"

ADD ./build-dicomweb.sh /root/build-dicomweb.sh
RUN bash /root/build-dicomweb.sh "OrthancDicomWeb-0.3"

ADD ./build-wsi.sh /root/build-wsi.sh
RUN bash /root/build-wsi.sh "OrthancWSI-0.4"

VOLUME [ "/var/lib/orthanc/db" ]
EXPOSE 4242
EXPOSE 8042

ENTRYPOINT [ "Orthanc" ]
CMD [ "/etc/orthanc/" ]
