import psignifit
from pymatreader import read_mat

# PC DATA_FOLDER = '/home/aflowers/Cloud/VisionLab/Abigail/CuspExperiment/Data/'
DATA_FOLDER = '/home/aflowers/Documents/VisionLab/Cloud/Abigail/CuspExperiment/Data/'

# testing reading from matlab!
data = read_mat(DATA_FOLDER + 'pp1_1_time739753.667795185_cusp_results.mat')
# work how to format this for psignifit functions
print(list(data.keys()))


