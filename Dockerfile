FROM centos:7

# epel for cabextract
RUN yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm \
    && yum install -y --setopt=tsflags=nodocs \
    java-1.8.0-openjdk \
    #
    # libreoffice requirements
    cairo \
    cups-libs \
    dbus-glib \
    glib2 \
    libSM \
    libXinerama \
    mesa-libGL \
    #
    # extra fonts
    gnu-free-mono-fonts \
    gnu-free-sans-fonts \
    gnu-free-serif-fonts \
    #
    # mscorefonts dependencies
    cabextract \
    curl \
    #
    # utilities
    unzip \
    wget \
    #
    && yum clean all \
    && rm -rf /var/cache/yum

RUN yum install -y https://downloads.sourceforge.net/project/mscorefonts2/rpms/msttcore-fonts-installer-2.6-1.noarch.rpm \
    && yum clean all \
    && rm -rf /var/cache/yum

ENV LIBREOFFICE_VERSION=6.1.4

# mirror list https://download.documentfoundation.org/mirmon/allmirrors.html
RUN wget http://mirror.sjc02.svwh.net/tdf/libreoffice/stable/${LIBREOFFICE_VERSION}/rpm/x86_64/LibreOffice_${LIBREOFFICE_VERSION}_Linux_x86-64_rpm.tar.gz \
    && tar -xf LibreOffice_${LIBREOFFICE_VERSION}_Linux_x86-64_rpm.tar.gz \
    && cd LibreOffice_*_Linux_x86-64_rpm/RPMS \
    && (rm -f *integ* || true) \
    && (rm -f *desk* || true) \
    && yum localinstall -y --setopt=tsflags=nodocs *.rpm \
    && yum clean all \
    && rm -rf /var/cache/yum \
    && cd ../.. \
    && rm -rf LibreOffice_*_Linux_x86-64_rpm \
    && rm -f LibreOffice_*_Linux_x86-64_rpm.tar.gz \
    && ln -s /opt/libreoffice* /opt/libreoffice

RUN groupadd docmosis \
    && useradd -g docmosis \
    --create-home \
    --shell /sbin/nologin \
    --comment "Docmosis user" \
    docmosis

WORKDIR /home/docmosis

ENV DOCMOSIS_VERSION=2.7.2_8016

RUN DOCMOSIS_VERSION_SHORT=$(echo $DOCMOSIS_VERSION | cut -f1 -d_ | cut -b-3) \
    && wget https://www.docmosis.com/download/tornado${DOCMOSIS_VERSION_SHORT}/docmosisTornado${DOCMOSIS_VERSION}.zip \
    && unzip docmosisTornado${DOCMOSIS_VERSION}.zip docmosisTornado*.war \
    && mv docmosisTornado*.war docmosisTornado.war \
    && rm -f docmosisTornado${DOCMOSIS_VERSION}.zip

COPY log4j.properties /home/docmosis/

USER docmosis
RUN mkdir /home/docmosis/templates /home/docmosis/workingarea

ENV DOCMOSIS_OFFICEDIR=/opt/libreoffice \
    DOCMOSIS_TEMPLATESDIR=templates \
    DOCMOSIS_WORKINGDIR=workingarea \
    DOCMOSIS_LOG4J_CONFIG_FILE=log4j.properties

EXPOSE 8080
VOLUME /home/docmosis/templates
CMD java -Ddocmosis.tornado.render.useUrl=http://localhost:8080/ -jar docmosisTornado.war
