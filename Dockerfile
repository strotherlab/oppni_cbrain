#Updated version from the git repo

# Call the docker file for afni to do the preliminary set up of ubuntu:trusty
FROM bids/base_afni

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
