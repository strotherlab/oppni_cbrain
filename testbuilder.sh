# This file is to test calling a  docker builder
echo 'Running Boutiques Command...'
echo 'Hello From the Builder Script!'

# Ensure Singularity is installed and loaded
echo 'Making sure singularity is loaded...'
if ! type singularity; 
then 
	echo 'Singularity Not Found!'
        echo 'Loading Singularity...'
	module load singularity; 
else
	echo 'Singularity Found!'
fi

# Append locally commands to the oppni sting
echo 'Preparing the OPPNI command...'
OPPNI_COMMAND="python $@ -e octave --run_locally --numcores 4"
echo 'Command to be Called:'
echo ">>> $OPPNI_COMMAND"

# Build the TEST DOCKER AUTO BUILD
echo 'Building the Docker...'
singularity build testdocker.img docker://andrewlofts/testdocker
#singularity exec 



#5. Tells the docker to execute the OPPNI Pipeline
echo 'Executing OPPNI inside the docker...'
#####singularity exec testdocker.img which python
#####singularity exec testdocker.img $OPPNI_COMMAND

#6. Tells the docker to execute the OPPNI--status to check job completeion
echo 'Checking OPPNI status...'
OPPNI_ARGS=("$@")
# Oppni Location
echo "Oppni Location >>> ${OPPNI_ARGS[0]}"
# Input File
echo "Input Location >>> ${OPPNI_ARGS[2]}"
######singularity exec doppni.img "{OPPNI_ARGS[0]}" -s "${OPPNI_ARGS[2]}"

#7. Aquires the OPPNI status log file and indicates to CBRAIN that the job is complete
echo 'Collecting OPPNI loga status for CBRAIN job completion...'






