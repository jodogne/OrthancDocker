# Orthanc for Docker
[Docker Hub](https://www.docker.com/) repository to build [Orthanc](http://www.orthanc-server.com/) and its official plugins. Orthanc is a lightweight, RESTful Vendor Neutral Archive for medical imaging.

_Note for CentOS users: The Docker environment might be difficult to configure on your platform. Hints are available on the [Orthanc Users discussion group](https://groups.google.com/d/msg/orthanc-users/w-uPAknnRQc/-XhzBGSCAwAJ)._

## Usage, with plugins disabled

The following command will run the core of Orthanc:

```
# sudo docker run -p 4242:4242 -p 8042:8042 --rm jodogne/orthanc
```

You can also force the [version of Orthanc](https://registry.hub.docker.com/u/jodogne/orthanc/tags/manage/) to be run:

```
# sudo docker run -p 4242:4242 -p 8042:8042 --rm jodogne/orthanc:1.1.0
```

Passing additional command-line options (e.g. to make Orthanc verbose) can be done as follows:

```
# sudo docker run -p 4242:4242 -p 8042:8042 --rm jodogne/orthanc /etc/orthanc --verbose
```

Once Orthanc is running, use Mozilla Firefox at URL [http://localhost:8042/](http://orthanc:orthanc@localhost:8042/app/explorer.html) to interact with Orthanc. The default username is `orthanc` and its password is `orthanc`.

## Fine-tuning the configuration

For security reasons, you should at least protect your instance of Orthanc by changing this default user, in the `RegisteredUsers` configuration option. You will also probably need to fine-tune other parameters, notably the list of the DICOM modalities Orthanc knows about.

You can create a custom [configuration file](https://orthanc.chu.ulg.ac.be/book/users/configuration.html) for Orthanc as follows:

```
# sudo docker run --rm --entrypoint=cat jodogne/orthanc /etc/orthanc/orthanc.json > /tmp/orthanc.json
  => Edit /tmp/orthanc.json
  => Modify the RegisteredUsers section
# sudo docker run -p 4242:4242 -p 8042:8042 --rm -v /tmp/orthanc.json:/etc/orthanc/orthanc.json:ro jodogne/orthanc
```

## Making the Orthanc database persistent

The filesystem of Docker containers is volatile (its content is deleted once the container stops). You can make the Orthanc database persistent by mapping the `/var/lib/orthanc/db` folder of the container to some path in the filesystem of your Linux host, e.g.:

```
# mkdir /tmp/orthanc-db
# sudo docker run -p 4242:4242 -p 8042:8042 --rm -v /tmp/orthanc-db/:/var/lib/orthanc/db/ jodogne/orthanc:1.0.0 
```

## Usage, with plugins enabled

The following command will run the mainline version of Orthanc, together with its [Web viewer](http://www.orthanc-server.com/static.php?page=web-viewer), its [PostgreSQL support](http://www.orthanc-server.com/static.php?page=postgresql), its [DICOMweb implementation](http://www.orthanc-server.com/static.php?page=dicomweb), and its [whole-slide imaging viewer](http://www.orthanc-server.com/static.php?page=wsi):

```
# sudo docker run -p 4242:4242 -p 8042:8042 --rm jodogne/orthanc-plugins
```

## Whole-slide imaging support

The `orthanc-plugins` image includes support for  [whole-slide imaging (WSI)](http://www.orthanc-server.com/static.php?page=wsi). For instance, the following command will start the WSI viewer plugin transparently together with Orthanc:

```
# sudo docker run -p 4242:4242 -p 8042:8042 --rm --name orthanc-wsi jodogne/orthanc-plugins:1.1.0
```

Note that we gave the name `orthanc-wsi` to this new Docker container. Then, the Dicomizer command-line tool can be invoked as follows:

```
# sudo docker run -t -i --rm --link=orthanc-wsi:orthanc --entrypoint=OrthancWSIDicomizer -v /tmp/Source.tif:/tmp/Source.tif:ro jodogne/orthanc-plugins --username=orthanc --password=orthanc --orthanc=http://orthanc:8042/ /tmp/Source.tif
```

This command needs a few explanations:
 * `--link=orthanc-wsi:orthanc` links the container running the Dicomizer, to the Docker container running Orthanc that we started just before.
 * `--entrypoint=OrthancWSIDicomizer` specifies that the Dicomizer must be run instead of the Orthanc server.
 * `-v /tmp/Source.tif:/tmp/Source.tif:ro` maps the source image `/tmp/Source.tif` on the host computer into the Orthanc container as read-only file `/tmp/Source.tif`.
 * `--orthanc=http://orthanc:8042/` instructs the Dicomizer to push images through the `--link` created above.
 * `--username=orthanc --password=orthanc` correspond to the default credentials of the `orthanc-plugins` image.

Obviously, you are free to add all the options you wish (check out the `--help` flag to list these options). In particular, the `--dataset` option allows to specify DICOM tags, in the JSON file format, so as to include them in the resulting DICOM series (the option `--sample-dataset` prints a sample JSON file that has the expected format).

If you have a source image that is not a hierarchical TIFF, you must instruct the Dicomizer to use [OpenSlide](http://openslide.org/) to decode it by adding the `--openslide` option:

```
# sudo docker run -t -i --rm --link=orthanc-wsi:orthanc --entrypoint=OrthancWSIDicomizer -v /tmp/Source.svs:/tmp/Source.svs:ro jodogne/orthanc-plugins --username=orthanc --password=orthanc --orthanc=http://orthanc:8042/ --openslide=libopenslide.so /tmp/Source.svs
```


## PostgreSQL and Orthanc inside Docker

It is possible to run both Orthanc and PostgreSQL inside Docker. First, start the official PostgreSQL container:

```
# sudo docker run --name some-postgres -e POSTGRES_USER=postgres -e POSTGRES_PASSWORD=pgpassword --rm postgres
```

Open another shell, and create a database to host the Orthanc database:

```
# sudo docker run -it --link some-postgres:postgres --rm postgres sh -c 'echo "CREATE DATABASE orthanc;" | exec psql -h "$POSTGRES_PORT_5432_TCP_ADDR" -p "$POSTGRES_PORT_5432_TCP_PORT" -U postgres'
```

You will have to type the password (cf. the environment variable `POSTGRES_PASSWORD` above that it set to `pgpassword`). Then, retrieve the IP and the port of the PostgreSQL container, together with the default Orthanc configuration file:

```
# sudo docker inspect --format '{{ .NetworkSettings.IPAddress }}' some-postgres
# sudo docker inspect --format '{{ .NetworkSettings.Ports }}' some-postgres
# sudo docker run --rm --entrypoint=cat jodogne/orthanc-plugins /etc/orthanc/orthanc.json > /tmp/orthanc.json
```

Add the following section to `/tmp/orthanc.json` (adapting the values `Host` and `Port` to what `docker inspect` said above):

```json
  "PostgreSQL" : {
    "EnableIndex" : true,
    "EnableStorage" : true,
    "Host" : "172.17.0.38",
    "Port" : 5432,
    "Database" : "orthanc",
    "Username" : "postgres",
    "Password" : "pgpassword"
  }
```

Finally, you can start Orthanc:

```
# sudo docker run -p 4242:4242 -p 8042:8042 --rm -v /tmp/orthanc.json:/etc/orthanc/orthanc.json:ro jodogne/orthanc-plugins
```

## Debugging

For debugging purpose, you can start an interactive bash session as follows:

```
# sudo docker run -i -t --rm --entrypoint=bash jodogne/orthanc
# sudo docker run -i -t --rm --entrypoint=bash jodogne/orthanc-plugins
```
