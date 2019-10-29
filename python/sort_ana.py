
# Gather the info from the simulations and make a huge binary file

import sys, os
from re import search
from shutil import copy as copyfile

def emptylist(length,length2=False,length3=False):
    if length3:
        return [emptylist(length2,length3) for i in range(length)]
    elif length2:
        return [emptylist(length2) for i in range(length)]
    else:
        return [[] for i in range(length)]

def get_files(path):
    """
    :param path: path of a folder
    :return: a list of relative paths to the current folder of all the folders in 'path'
    """
    lista = os.listdir(path)
    listb = list()
    nd_file = None
    for name in lista:
        if name[-3:] in ['TIF','tif']:
            listb.append(name)
        elif name[-2:] == "nd":
            nd_file = name;

    return listb, nd_file

class nd_info:

    def __init__(self):
        self.nb_chan = str()
        self.chan_names = list()
        self.nb_tpoints = int()
        self.nb_stages = int()
        self.nb_z = int()
        self.z_step = int()
        self.do_z = list()
    def process(self,filename):
        print filename
        with open(filename,'r') as ins:
            for line in ins:
                l = line.split(',')
                # Remove the newline character
                l[-1] = l[-1].rstrip()
                if l[0] == '"NTimePoints"':

                    self.nb_tpoints = int(l[1])
                elif l[0] == '"NZSteps"':
                    self.nb_z = int(l[1])
                elif l[0][:9] == '"WaveName':
                    # Remove the quote from the name and the underscore which for some reason changes
                    self.chan_names.append(l[1][4:-1])
                elif l[0] == '"ZStepSize"':
                    self.z_step = int(l[1])
                elif l[0] == '"NStagePositions"':
                    self.nb_stages = int(l[1])
                elif l[0][:8] == '"WaveDoZ':
                    self.do_z.append("TRUE" in l[1])
        self.do_z = [self.nb_z if i else 1 for i in self.do_z]
        self.nb_chan = len(self.chan_names)
    def sort(self,path,files):

        # Make the master directory
        master_dir = os.path.join(path, 'sorted')
        if not os.path.isdir(master_dir):
            os.mkdir(master_dir)

        # Make the directories corresponding to the positions and copy the files into them
        new_dirs = list()
        # List that will contain the name of the files associated with each channel
        mat_info = emptylist(self.nb_stages,self.nb_chan,self.nb_tpoints)
        for i in range(self.nb_stages):
            for j in range(self.nb_chan):
                for k in range(self.nb_chan):
                    mat_info[i][j][k][:] = ""
        for i in range(self.nb_stages):
            name = os.path.join(master_dir, 'pos_' + str(i + 1))
            if not os.path.isdir(name):
                os.mkdir(name)

            new_dirs.append(name)

        # Copy the data


        for name in files:
            match = search('_s([\d]+)_',name)
            if match:
                i = int(match.group(1))
                copyfile(os.path.join(path,name),new_dirs[i-1])
                # This is probably inefficient but its fine
                match2 = search('_t([\d]+)', name)
                for j, channel in enumerate(self.chan_names):
                    if channel in name:
                        mat_info[i-1][j][int(match2.group(1))-1] = name

        for i,d in enumerate(new_dirs):
            print d
            with open(os.path.join(d,"guide.m"),'w') as ins:
                ins.write("channels = {")
                for ele in self.chan_names:
                    ins.write("'" + ele + "',")
                ins.write("};"+os.linesep)
                ins.write("files = {")
                for lis in mat_info[i]:
                    ins.write("{")
                    for ele in lis:
                        # sometimes ele is an empty list if the file is missing, then it should not write anything
                        if len(ele):
                            ins.write("'"+ele+"',")
                    ins.write("},")
                ins.write("};" + os.linesep)
                ins.write("nb_z = " + str(self.do_z) + ";")
                ins.write("nb_chan = "+ str(self.nb_chan) + ";")
                ins.write("nb_tpoints = " + str(self.nb_tpoints) + ";")
                ins.write("z_step = " + str(self.z_step) + ";")


def main(args):
    for path in args:
        file_list, nd_file = get_files(path)
        h = nd_info()
        h.process(os.path.join(path,nd_file))
        h.sort(path,file_list)
    return

# if __name__ == "__main__":
#     if len(sys.argv) < 2 or sys.argv[1] == 'help':
#         print(__doc__)
#     else:
#         main(sys.argv[1:])

main(['./'])