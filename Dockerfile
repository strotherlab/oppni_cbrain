# FROM
#######################################################################
# Call the docker file for afni to do the preliminary set up of ubuntu:trusty
FROM ubuntu:cosmic

# No bids validation...

## Install the validator
#RUN    apt-get update 
#RUN    apt-get install -y curl 
#RUN    curl -sL https://deb.nodesource.com/setup_4.x | bash - 
#RUN    apt-get remove -y curl 
#RUN    apt-get install -y nodejs 
#RUN    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

#RUN npm install -g bids-validator@0.19.2

RUN apt-get update
RUN apt-get install -y gnupg

# AFNI (bids/base_afni)
####################################
RUN apt-get update 
RUN    apt-get install -y curl
RUN    curl -sSL http://neuro.debian.net/lists/bionic.us-ca.full >> /etc/apt/sources.list.d/neurodebian.sources.list 
#RUN    curl -sSL http://neuro.debian.net/lists/trusty.us-ca.full >> /etc/apt/sources.list.d/neurodebian.sources.list 
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

# Python 2 & 3
#########################################
RUN apt-get install -y python-pip

# default to 3.6
RUN ln -sfn /usr/bin/python3.6 /usr/bin/python
RUN apt-get install -y python3-pip
RUN apt-get install -y python3-distutils

#Install pybids for use later
#########################################
RUN pip3 install --upgrade pip
RUN pip3 install pybids

#An editor
#########################################
RUN apt-get install nano


# Get Tools needed if you want to build Octave from source uncomment the following
##################################################################################
# core prereqs
#RUN apt-get install -y g++ make gawk gfortran gnuplot texi2html icoutils libxft-dev gperf flex libbison-dev libqhull-dev libglpk-dev libcurl4-gnutls-dev librsvg2-dev libqrupdate-dev libgl2ps-dev libarpack2-dev libreadline-dev libncurses-dev libhdf5-dev llvm-dev default-jdk texinfo libfftw3-dev libgraphicsmagick++1-dev libfreeimage-dev transfig epstool librsvg2-bin libosmesa6-dev libsndfile-dev lzip libatlas-base-dev liblapack-dev libsundials-dev

# graphical prereqs
#RUN apt-get install -y qtbase5-dev qttools5-dev libqscintilla2-qt5-dev

RUN apt-get install -y wget
RUN mkdir -p /octave_source/
RUN cd /octave_source/
#RUN wget https://ftp.gnu.org/gnu/octave/octave-4.4.1.tar.gz
#RUN wget https://ftp.gnu.org/gnu/octave/octave-4.4.1.tar.gz.sig
#RUN tar -xzf octave-4.4.1.tar.gz -C /octave_source/
#RUN mkdir -p ~/.local/octave
#RUN cd /octave_source/octave-4.4.1/
#RUN ./configure --prefix=$HOME/.local/octave

# We are now all set up to compile Octave
# Uncomment the following to complie and install GNU Octave.
# May take 30-60 minutes 
#########################################################
#RUN make -j -l4 CFLAGS=-O CXXFLAGS=-O LDFLAGS=
#RUN make install

#To use this new GNU Octave by addthe folowing to ~/.bash_aliases
#alias octave="$HOME/.local/octave/bin/octave -q"

# Gets the available Compiled Octave/stable
##########################################
RUN apt-get install -y software-properties-common
RUN apt-get install -y libqt5core5a
RUN apt-get update

RUN apt-get install -qy octave liboctave-dev
RUN apt-get install -y octave-io octave-control octave-struct octave-statistics octave-signal octave-optim

#fixup libQt5Core.so.5
RUN apt-get install libqt5core5a --reinstall
RUN strip --remove-section=.note.ABI-tag /usr/lib/x86_64-linux-gnu/libQt5Core.so.5

#ADD stuff to bashrc
#RUN echo 'Add this line to bashrc' >> ~/.bashrc

RUN mkdir /cbrain/
ENV OCTAVE_VERSION_INITFILE=/cbrain/.octaverc
COPY .octaverc /cbrain/
COPY CBRAIN_path_replace.py /cbrain/
RUN  chmod a+x /cbrain/CBRAIN_path_replace.py


#OPPNI IS DOCKED!
