#Updated version from the git repo

# Call the docker file for afni to do the preliminary set up of ubuntu:trusty
FROM ubuntu:trusty

## VALIDATOR DOCKER START
RUN apt-get update && \
    apt-get install -y curl && \
    curl -sL https://deb.nodesource.com/setup_4.x | bash - && \
    apt-get remove -y curl && \
    apt-get install -y nodejs && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN npm install -g bids-validator@0.19.2

# AFNI DOCKER START
RUN apt-get update && \
    apt-get install -y curl && \
    curl -sSL http://neuro.debian.net/lists/trusty.us-ca.full >> /etc/apt/sources.list.d/neurodebian.sources.list && \
    apt-key adv --recv-keys --keyserver hkp://pgp.mit.edu:80 0xA5D32F012649A5A9 && \
    apt-get update && \
    apt-get remove -y curl && \
    apt-get install -y afni && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

#FSL

RUN apt-get update && \
    apt-get install -y curl && \
    curl -sSL http://neuro.debian.net/lists/trusty.us-ca.full >> /etc/apt/sources.list.d/neurodebian.sources.list && \
    apt-key adv --recv-keys --keyserver hkp://pgp.mit.edu:80 0xA5D32F012649A5A9 && \
    apt-get update && \
    apt-get remove -y curl && \
    apt-get install -y fsl-core && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*


# Configure environment
ENV FSLDIR=/usr/share/fsl/5.0
ENV FSLOUTPUTTYPE=NIFTI_GZ
ENV PATH=/usr/lib/fsl/5.0:$PATH
ENV FSLMULTIFILEQUIT=TRUE
ENV POSSUMDIR=/usr/share/fsl/5.0
ENV LD_LIBRARY_PATH=/usr/lib/fsl/5.0:$LD_LIBRARY_PATH
ENV FSLTCLSH=/usr/bin/tclsh
ENV FSLWISH=/usr/bin/wish
ENV FSLOUTPUTTYPE=NIFTI_GZ


##############################################





#CMD echo "Hello from inside the docker???"
#CMD mkdir ./iamafoldercreatedbythedocker


CMD echo "Hello from inside the docker???"
CMD ["/bin/bash", "-c", "echo Hello, Hello exec form"]
RUN echo "Hello from run shell form"
RUN ["/bin/bash", "-c", "echo Hello, Hello run exec command"]
#RUN echo "Hello from run shell form"
ENTRYPOINT ["/bin/bash", "-c", "echo Hello, Hello run exec command"]

# Configure environment and set to path
ENV AFNI_PATH=/usr/lib/afni/bin
ENV FSLDIR=/usr/share/fsl/5.0
ENV FSL_PATH $FSLDIR/bin/
ENV FSLOUTPUTTYPE=NIFTI_GZ

#ENV LD_LIBRARY_PATH=/usr/lib/fsl/5.0

#ENV OPPNI_PATH=
ENV PATH $AFNI_PATH:$FSL_PATH:$OPPNI_PATH:$PATH

# Gets python 
#RUN apt-get install -y python

# Gets Octave
#RUN  add-apt-repository ppa:octave/stable
#RUN  apt-get update
#RUN  apt-get install octave

# Docker is commanded to do OPPNI from external bashfile...
# 	OPPNI will run in the pwd
# 	It will create a folder based on the input file information
# 	Oppni will create a folder processing*

# Docker is commanded to do OPPNI status check from external bashfile...
# Need to make a file?????
