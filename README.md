# Docmosis Tornado Docker Image BETA

To run the Docmosis Tornado Docker image use the **docker run** command as follows:

    docker run --name <container name> \
      -p <host port>:8080 \
      -v <host templates directory>:/home/docmosis/templates \
      mikehodgson/tornado

    Parameters:
      --name: The name of the container (default: auto generated).
      -p:     The port mapping of the host port to the container port.
              Port 8080 is used for both the REST service and the web console.
      -v:     The absolute path to your templates directory on the host system.
