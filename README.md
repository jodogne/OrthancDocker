# Orthanc for Docker
[Docker Hub](https://www.docker.com/) repository to build [Orthanc](http://www.orthanc-server.com/) and its official plugins. Orthanc is a lightweight, RESTful Vendor Neutral Archive for medical imaging.

## Usage, with plugins disabled

The following command will run the core of Orthanc:

```
# sudo docker run -p 4242:4242 -p 8042:8042 jodogne/orthanc
```

Once Orthanc is running, use Mozilla Firefox at URL [http://localhost:8042/](http://orthanc:orthanc@localhost:8042/app/explorer.html) to interact with Orthanc. The default username is `orthanc` and its password is `orthanc`.

For security reasons, you should protect your instance of Orthanc by changing this default user, in the `RegisteredUsers` configuration option. You can use a custom [configuration file](https://code.google.com/p/orthanc/wiki/OrthancConfiguration) for Orthanc as follows:

```
# sudo docker run --entrypoint=cat jodogne/orthanc /etc/orthanc/orthanc.json > /tmp/orthanc.json
  => Edit /tmp/orthanc.json
  => Modify the RegisteredUsers section
# sudo docker run -p 4242:4242 -p 8042:8042 -v /tmp/orthanc.json:/etc/orthanc/orthanc.json:ro jodogne/orthanc
```

## Usage, with plugins enabled

The following command will run Orthanc, together with its [Web viewer](https://code.google.com/p/orthanc-webviewer/), its [PostgreSQL support](https://code.google.com/p/orthanc-postgresql/) and its [DICOMweb implementation](https://bitbucket.org/sjodogne/orthanc-dicomweb/):

```
# sudo docker run -p 4242:4242 -p 8042:8042 jodogne/orthanc-plugins
```
