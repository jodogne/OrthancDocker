FROM orthanc

MAINTAINER Sebastien Jodogne <s.jodogne@gmail.com>
LABEL Description="Official plugins for Orthanc" Vendor="Sebastien Jodogne, University Hospital of Liege"

RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install libgdcm2-dev libjpeg-dev postgresql-server-dev-all && rm -rf /var/lib/apt/lists/*

ADD ./build-webviewer.sh /home/build-webviewer.sh
RUN bash /home/build-webviewer.sh "default"

ADD ./build-postgresql.sh /home/build-postgresql.sh
RUN bash /home/build-postgresql.sh "default"

ADD ./build-dicomweb.sh /home/build-dicomweb.sh
RUN bash /home/build-dicomweb.sh "default"

VOLUME [ "/var/lib/orthanc/db" ]
EXPOSE 4242
EXPOSE 8042

ENTRYPOINT [ "Orthanc" ]
CMD [ "/etc/orthanc/orthanc.json" ]
