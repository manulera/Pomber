import os, sys
import numpy as np
import fnmatch as fm


def emptylist(length,length2=False,length3=False):
    if length3:
        return [emptylist(length2,length3) for i in range(length)]
    elif length2:
        return [emptylist(length2) for i in range(length)]
    else:
        return [[] for i in range(length)]


def get_files(path,filt=None):



    lista = os.listdir(path)
    lista.sort()
    listb = list()
    ind = list()
    cell_names = open(os.path.join(path,'order.txt'),'a')

    for name in lista:
        sp = name.split('_')
        if filt is None:
            if os.path.isfile(os.path.join(name, 'order.txt')):
                    folder = os.path.join(path,name)
                    with open(os.path.join(folder,'order.txt')) as ins:
                        for line in ins:
                            cell_names.write(os.path.join(folder, line))
                    listb.append(name)


        else:
            if sp[0]==filt:
                listb.append(name)
                ind.append(int(sp[1])-1)
                cell_names.write(name)
                if os.path.isfile(os.path.join(path,name,"categories.txt")):
                    with open(os.path.join(path,name,"categories.txt"),"r") as ins:
                        content = ins.readline().strip()
                        cell_names.write(" " + content)
                cell_names.write(os.linesep)
    cell_names.close()
    # Sort the list appropiately, alphabetic sorting will not work when _1, _10, _2
    outlist = emptylist(len(listb))
    if filt is None:
        outlist = listb
    else:
        sorter = np.argsort(ind)

        for i,j in enumerate(sorter): outlist[i] = listb[j]

    return outlist


class splist:
    # A class to return '' if you go over the limit of length of the list, this is useful to print the column files
    def __init__(self,inlist):
        self.l = list(inlist)
    def __getitem__(self, item):
        if item<(len(self.l)):
            return self.l[item]
        else:
            return ''
    def __len__(self):
        return len(self.l)

    def append(self,item):
        self.l.append(item)

    def __iadd__(self, other):
        if type(other)==list:
            self.l += other
        elif type(other)==splist:
            self.l += other.l

def collect_pair(fname ,inds=False, delimiter=',',remove_last=False):
    """

    :param fname: the name of the file
    :param inds: the indexes of the elements in each row of the file that you want to store in output list
    :return: a list with n elements where n is the number of lines in fname, and each element of the ist is one element in the line
     corresponding to the indexes in "inds
    """

    a = np.genfromtxt(fname, delimiter=delimiter, dtype=str)
    if remove_last:
        a = a[:,:-1]
    if not inds:
        inds = range(a.shape[1])
    else:
        # SUbstract one to get the right values
        inds = [i-1 for i in inds]
    outlist = [splist(a[:,i]) for i in inds]

    return outlist


def print_filecols(filname,lis):
    # Look for the longest list
    lens = [len(i) for i in lis]
    n_cols = max(lens)
    with open(filname,'w') as out:
        for c in range(n_cols):
            for l in lis:
                out.write(l[c]+',')
            # Generic linebreak
            out.write(os.linesep)

def process_folders(path,folders,an_folder,filename,inds,out_names,dirname):

    for i in range(len(inds)):
        lis = list()
        any_spindle = False
        for f in folders:
            if os.path.isdir(os.path.join(f,an_folder)):
                any_spindle = True
                lis+=collect_pair(os.path.join(f,an_folder,filename),inds[i])
        if any_spindle:
            dirname = os.path.join(path, dirname)
            if not os.path.isdir(dirname):
                os.mkdir(dirname)
            print_filecols(os.path.join(dirname,out_names[i]),lis)

def process_folders_pos(path,pos,an_folder,files):

    for name in files:
        lis = list()
        any_an = False
        for p in pos:
            if os.path.isdir(os.path.join(path,p, an_folder)):
                any_an = True
                lis+=collect_pair(os.path.join(path,p,an_folder,name),remove_last=True)
        if any_an:
            dirname = os.path.join(path, an_folder)
            if not os.path.isdir(dirname):
                os.mkdir(dirname)
            print_filecols(os.path.join(dirname, name), lis)



def process_folders_spindle(path,folders):
    inds = [[1,2] ,[1,3],[2,3]]
    out_names = ["sp_t_len.txt","sp_t_dist.txt","sp_len_dist.txt"]
    process_folders(path,folders,'spindle','t_len_dist_um.txt',inds,out_names,"all_spindle")

    inds = [[1, 2], [1, 3]]
    out_names = ["sp_len_ratiotubulin.txt", "sp_len_totaltubulin.txt"]
    process_folders(path,folders,'spindle',"len_ratio_totint_um.txt", inds, out_names, "all_spindle")

def process_folders_spindle_pos(path,pos):
    names = ["sp_t_len.txt", "sp_t_dist.txt", "sp_len_dist.txt","sp_len_ratiotubulin.txt", "sp_len_totaltubulin.txt"]
    process_folders_pos(path,pos, 'all_spindle', names)


def process_folders_ios(path,folders):

    inds = [[1,2] ,[1,3]]
    out_names = ["ios_len_ratio.txt","ios_len_tot.txt"]
    process_folders(path,folders,'int_on_spindle','len_ratio_totint_um.txt',inds,out_names,"all_ios")

def process_folders_ios_pos(path,pos):
    names = ["ios_len_ratio.txt","ios_len_tot.txt"]
    process_folders_pos(path,pos, 'all_ios', names)

def process_folders_dots(path,folders):

    inds = [[1,2]]
    out_names = ["t_dist.txt"]
    process_folders(path,folders, 'dots', 't_dist_um.txt', inds, out_names, "all_dots")

def process_folders_dots_pos(path,pos):
    names = ["t_dist.txt"]
    process_folders_pos(path,pos, 'all_dots', names)


def gather_frompos(path, pos):

    process_folders_spindle_pos(path,pos)
    process_folders_ios_pos(path,pos)
    process_folders_dots_pos(path,pos)

def gather_fromcells(path):

    files = get_files(path, 'cell')

    process_folders_spindle(path,files)
    process_folders_ios(path,files)
    process_folders_dots(path,files)
    return

def get_files_position(path):
    lista = os.listdir(path)
    lista.sort()
    out_list = list()
    for f in lista:
        if os.path.isfile(os.path.join(f,'order.txt')):
            out_list.append(f)
    return out_list

def main(args):
    for path in args:
        order_file = os.path.join(path, 'order.txt')
        if os.path.isfile(order_file):
            os.remove(order_file)

        files = get_files(path)

        if len(files)<1:
            print "Gather from cells"
            gather_fromcells(path)
        else:
            print "Gather from positions"
            gather_frompos(path, files)

    return

if __name__ == "__main__":
    if len(sys.argv) < 2:
        main(['.'])
    else:
        main(sys.argv[1:])
