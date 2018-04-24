FROM jodogne/base

MAINTAINER Sebastien Jodogne <s.jodogne@gmail.com>
LABEL Description="Orthanc, free DICOM server" Vendor="The Orthanc project"

RUN apt-get clean && apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install libgdcm2-dev libjpeg-dev postgresql-server-dev-all libtiff-dev libopenjpeg-dev libopenslide-dev && rm -rf /var/lib/apt/lists/*

ADD ./build-orthanc.sh /root/build-orthanc.sh
RUN bash /root/build-orthanc.sh "default"

ADD ./build-webviewer.sh /root/build-webviewer.sh
RUN bash /root/build-webviewer.sh "default"

ADD ./build-postgresql.sh /root/build-postgresql.sh
RUN bash /root/build-postgresql.sh "default"

ADD ./build-dicomweb.sh /root/build-dicomweb.sh
RUN bash /root/build-dicomweb.sh "default"

ADD ./build-wsi.sh /root/build-wsi.sh
RUN bash /root/build-wsi.sh "default"

VOLUME [ "/var/lib/orthanc/db" ]
EXPOSE 4242
EXPOSE 8042

ENTRYPOINT [ "Orthanc" ]
CMD [ "/etc/orthanc/" ]
