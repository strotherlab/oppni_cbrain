# FROM
#######################################################################
# Call the docker file for afni to do the preliminary set up of ubuntu:trusty
FROM ubuntu:trusty
# No bids validation...

## Install the validator
RUN    apt-get update 
RUN    apt-get install -y curl 
RUN    curl -sL https://deb.nodesource.com/setup_4.x | bash - 
RUN    apt-get remove -y curl 
RUN    apt-get install -y nodejs 
RUN    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN npm install -g bids-validator@0.19.2

# AFNI (bids/base_afni)
####################################
RUN apt-get update 
RUN    apt-get install -y curl
RUN    curl -sSL http://neuro.debian.net/lists/trusty.us-ca.full >> /etc/apt/sources.list.d/neurodebian.sources.list 
RUN    apt-key adv --recv-keys --keyserver hkp://pgp.mit.edu:80 0xA5D32F012649A5A9 
RUN    apt-get update
RUN    apt-get remove -y curl
RUN    apt-get install -y afni
RUN    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# FSL (bids/base_fsl)
#####################################
RUN    apt-get update 
RUN    apt-get install -y curl 
RUN    curl -sSL http://neuro.debian.net/lists/trusty.us-ca.full >> /etc/apt/sources.list.d/neurodebian.sources.list 
RUN    apt-key adv --recv-keys --keyserver hkp://pgp.mit.edu:80 0xA5D32F012649A5A9 
RUN    apt-get update 
RUN    apt-get remove -y curl 
RUN    apt-get install -y fsl-core
RUN    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*


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


# OPPNI related
#########################################

ENV AFNI_PATH=/usr/lib/afni/bin
ENV FSLDIR=/usr/share/fsl/5.0
ENV FSL_PATH $FSLDIR/bin/
ENV FSLOUTPUTTYPE=NIFTI_GZ
# Hardcoded location from git pull
ENV OPPNI_PATH=/oppni
ENV PATH $AFNI_PATH:$FSL_PATH:$OPPNI_PATH:$PATH


# Git
RUN apt-get update
RUN apt-get install -qy git
# TAKE A TEST REPO THATS PUBLIC FOR NOW
# RUN git clone https://github.com/AndrewLofts/planets.git
# OPPNI IS PRIVATE AT THE MOMENT!
RUN git clone --branch frontenac_integration https://github.com/AndrewLofts/oppni.git
#RUN git clone --branch frontenac_integration https://github.com/raamana/oppni.git

# Python
#RUN apt-get install python 

# Gets Octave
RUN apt-get install -y software-properties-common
RUN add-apt-repository ppa:octave/stable
RUN apt-get update
RUN apt-get install -qy octave liboctave-dev
RUN apt-get install -y octave-io octave-control octave-struct octave-statistics octave-signal octave-optim

RUN mkdir /cbrain/
ENV OCTAVE_VERSION_INITFILE=/cbrain/.octaverc
COPY .octaverc /cbrain/
COPY CBRAIN_path_replace.py /cbrain/
RUN  chmod a+x /cbrain/CBRAIN_path_replace.py





#OPPNI IS DOCKED!
