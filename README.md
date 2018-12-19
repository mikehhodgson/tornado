# Docmosis Tornado Docker Image BETA

As of version 2.7.1, Tornado configuration may be supplied as environment variables.
To run the Docmosis Tornado Docker image use the **docker run** command as follows.

    docker run --name <container name> \
      -p <host port>:8080 \
      -v <host templates directory>:/home/docmosis/templates \
      -e DOCMOSIS_KEY=<license key> \
      -e DOCMOSIS_SITE=<license site> \
      mikehodgson/tornado

    Parameters:
      --name  The name of the container (default: auto generated).
      -p      The port mapping of the host port to the container port.
              Port 8080 is used for both the REST service and the web console.
      -v      The absolute path to your templates directory on the host system.
      -e      Set environment variables inside the container.

The `DOCMOSIS_SITE` variable will require quotes due to the spaces in the license site string:

    -e DOCMOSIS_SITE="Free Trial License"

For a full list of configurable environment variables, please see the [Tornado Getting Started Guide [PDF]](https://www.docmosis.com/download/tornado2.7/Tornado-Getting-Started-Guide2.7.pdf), available on the [Tornado Resources page](https://www.docmosis.com/resources/tornado.html).

## Trial Licence

[Please visit docmosis.com to request a free Tornado trial license.](https://www.docmosis.com/try/tornado.html)
