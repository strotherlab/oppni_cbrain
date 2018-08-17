
from collections import namedtuple
import os
import re
import sys
from os.path import join as pjoin
from os.path import dirname as pdirname
from os.path import basename as pbasename
from os.path import isdir as pisdir

# Set up
#####################################
#Call: python3 CBRAIN_path_replace.py /input_file.txt /real/crbrain/location

# [IN_FILE] = location of the original -i file containing missing paths
# [CBRAIN_PROCESSING_LOCATION] = "cbrain location path generated and given to boutique"......

# Open input file
# Loop through each line
#     find and replace every /CBRAIN_PROCESSING_LOCATION/ with the boutique varible
# save and modify the file name

# Boutique will have a hardcoded [IN_FILE]_cbrain location to call oppni with

# Initialize
line_text = []
out_text = []

# Gather command line inputs
input_file_og = sys.argv[1]
real_cbrain_path = sys.argv[2]

def main():
    # Read and Save the Original Input File to Work From
    with open(input_file_og, 'r') as ipf_og:
        for idx, line in enumerate(ipf_og.readlines()):
            line_text.append(line.strip())

    # Make and Write a Modified Input File
    input_file_mod = pjoin(pdirname(input_file_og),os.path.splitext(pbasename(input_file_og))[0] + '_cbrain.txt')
    #input_file_mod = pjoin(pdirname(input_file_og),pbasename(input_file_og) + '_cbrain.txt')
    with open(input_file_mod, 'w+') as ipf_mod:
        for idx in range(len(line_text)):
            mod_line_text = line_text[idx].replace("/CBRAIN_PROCESSING_LOCATION", real_cbrain_path)
            ipf_mod.write(mod_line_text + "\n")

if __name__ == '__main__':
    main()
