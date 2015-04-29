FROM base

MAINTAINER Sebastien Jodogne <s.jodogne@gmail.com>
LABEL Description="Latest release of Orthanc" Vendor="Sebastien Jodogne, University Hospital of Liege"

ADD ./build.sh /home/build.sh
RUN bash /home/build.sh "default"

VOLUME [ "/var/lib/orthanc/db" ]
EXPOSE 4242
EXPOSE 8042

ENTRYPOINT [ "Orthanc" ]
CMD [ "/etc/orthanc/orthanc.json" ]
