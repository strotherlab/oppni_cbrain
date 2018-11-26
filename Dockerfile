# FROM
#######################################################################
# Call the docker file for afni to do the preliminary set up of ubuntu:trusty
FROM ubuntu:xenial

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
#RUN    apt-key adv --recv-keys --keyserver hkp://pgp.mit.edu:80 0xA5D32F012649A5A9
RUN    apt-key adv --recv-keys --keyserver hkp://ha.pool.sks-keyservers.net:80 0xA5D32F012649A5A9 
RUN    apt-get update
RUN    apt-get remove -y curl
RUN    apt-get install -y afni
RUN    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# FSL (bids/base_fsl)
#####################################
RUN    apt-get update 
RUN    apt-get install -y curl 
RUN    curl -sSL http://neuro.debian.net/lists/trusty.us-ca.full >> /etc/apt/sources.list.d/neurodebian.sources.list 
#RUN    apt-key adv --recv-keys --keyserver hkp://pgp.mit.edu:80 0xA5D32F012649A5A9
RUN    apt-key adv --recv-keys --keyserver hkp://ha.pool.sks-keyservers.net:80 0xA5D32F012649A5A9 
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

# Install virtual dispaly framebuffer for X
###########################################
RUN apt-get update
RUN apt-get install -y xvfb
# invoke xvfb at run time
#Xvfb :88 -screen 0 1024x768x24 >& /dev/null &
#export DISPLAY=':88'


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
# OPPNI IS PRIVATE AT THE MOMENT!
RUN git clone --branch frontenac_integration https://github.com/mprati/oppni.git
#RUN git clone --branch frontenac_integration https://github.com/raamana/oppni.git

# Python
#RUN apt-get install python 

# Gets Octave/stable
#RUN apt-get install -y software-properties-common
#RUN add-apt-repository ppa:octave/stable
#RUN apt-get update
#RUN apt-get install -qy octave liboctave-dev
#RUN apt-get install -y octave-io octave-control octave-struct octave-statistics octave-signal octave-optim

# Lets build the lastes version of Octave
#########################################
#get tools and libs
#RUN apt-get install gcc g++ gfortran make libblas-dev liblapack-dev libpcre3-dev libarpack2-dev libcurl4-gnutls-dev epstool libfftw3-dev transfig libfltk1.3-dev libfontconfig1-dev libfreetype6-dev libgl2ps-dev libglpk-dev libreadline-dev gnuplot-x11 libgraphicsmagick++1-dev libhdf5-serial-dev openjdk-8-jdk libsndfile1-dev llvm-dev lpr texinfo libgl1-mesa-dev libosmesa6-dev pstoedit portaudio19-dev libqhull-dev libqrupdate-dev libqscintilla2-dev libqt4-dev libqtcore4 libqtwebkit4 libqt4-network libqtgui4 libqt4-opengl-dev libsuitesparse-dev texlive libxft-dev zlib1g-dev autoconf automake bison flex gperf gzip icoutils librsvg2-bin libtool perl rsync tar

#download source tar
#RUN apt-get 

#RUN apt-get install -y software-properties-common
#RUN add-apt-repository "deb http://us.archive.ubuntu.com/ubuntu/ cosmic universe"
#RUN apt-get update
#RUN apt-get install -qy octave/cosmic liboctave-dev
#RUN apt-get install -y octave-io/cosmic octave-control/cosmic octave-struct/cosmic octave-statistics/cosmic octave-signal/cosmic octave-optim/cosmic


RUN mkdir /cbrain/
ENV OCTAVE_VERSION_INITFILE=/cbrain/.octaverc
COPY .octaverc /cbrain/
COPY CBRAIN_path_replace.py /cbrain/
RUN  chmod a+x /cbrain/CBRAIN_path_replace.py


#OPPNI IS DOCKED!
