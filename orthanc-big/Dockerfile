FROM jodogne/base

MAINTAINER Sebastien Jodogne <s.jodogne@gmail.com>
LABEL Description="Orthanc, free DICOM server" Vendor="The Orthanc project"

ADD ./build-orthanc.sh /root/build-orthanc.sh
RUN bash /root/build-orthanc.sh "default"

VOLUME [ "/var/lib/orthanc/db" ]
EXPOSE 4242
EXPOSE 8042

ENTRYPOINT [ "Orthanc" ]
CMD [ "/etc/orthanc/" ]
