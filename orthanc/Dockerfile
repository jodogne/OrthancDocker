FROM jodogne/base

MAINTAINER Sebastien Jodogne <s.jodogne@gmail.com>
LABEL Description="Latest release of Orthanc" Vendor="Sebastien Jodogne, University Hospital of Liege"

ADD ./build.sh /root/build.sh
RUN bash /root/build.sh "default"

VOLUME [ "/var/lib/orthanc/db" ]
EXPOSE 4242
EXPOSE 8042

ENTRYPOINT [ "Orthanc" ]
CMD [ "/etc/orthanc/" ]
