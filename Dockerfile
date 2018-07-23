# FROM
#######################################################################
# Call the docker file for afni to do the preliminary set up of ubuntu:trusty
FROM ubuntu:trusty
# No bids validation...

# AFNI (bids/base_afni)
####################################
RUN apt-get update && \
    apt-get install -y curl && \
    curl -sSL http://neuro.debian.net/lists/trusty.us-ca.full >> /etc/apt/sources.list.d/neurodebian.sources.list && \
    apt-key adv --recv-keys --keyserver hkp://pgp.mit.edu:80 0xA5D32F012649A5A9 && \
    apt-get update && \
    apt-get remove -y curl && \
    apt-get install -y afni && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# FSL (bids/base_fsl)
#####################################
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


OPPNI related
#########################################

ENV AFNI_PATH=/usr/lib/afni/bin
ENV FSLDIR=/usr/share/fsl/5.0
ENV FSL_PATH $FSLDIR/bin/
ENV FSLOUTPUTTYPE=NIFTI_GZ
ENV PATH $AFNI_PATH:$FSL_PATH:$OPPNI_PATH:$PATH

RUN apt-get update
RUN apt-get install git
#NEED SUDO TO INSTALL GIT INSIDE DOCKER
RUN git clone --branch octave https://github.com/AndrewLofts/oppni.git
#OPPNI IS PRIVATE AT THE MOMENT!


# Gets python 
# ALREADY HAS PYTHON, NEED SUDO FOR DIFF INSTALL
RUN apt-get install -y python

# Gets Octave
# NEED SUDO FOR INSTALL INSIDE DOCKER
RUN  add-apt-repository ppa:octave/stable
RUN  apt-get update
RUN  apt-get install octave



###################################################
# Docker is commanded to do OPPNI status check from external bashfile...
# Need to make a file?????
