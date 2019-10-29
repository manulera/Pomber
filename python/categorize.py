import os
import sys
import numpy as np


def subsection_colfile(filename,which):
    array = np.genfromtxt(filename, delimiter=',', dtype=str)
    array = array[:,:-1]
    return array[:,which]

def copyfolder_idx(ori,dest,idx):
    if not os.path.isdir(ori):
        return
    bname = os.path.basename(ori)
    dest = os.path.join(dest,bname)
    if not os.path.isdir(dest):
        os.mkdir(dest)
    all_files = os.listdir(ori)

    for f in all_files:
        array = subsection_colfile(os.path.join(ori,f),idx)
        np.savetxt(os.path.join(dest,f),array,delimiter=",",fmt="%s")

def main(args):

    for path in args:

        order_file = os.path.join(path, 'order.txt')
        if not os.path.isfile(order_file):
            os.error("Error: No order.txt file")

        cat_dir = os.path.join(path,'categorised')
        if not os.path.isdir(cat_dir):
            os.mkdir(cat_dir)

        cats = list()
        dirs = list()
        with open(order_file) as ins:
            for line in ins:
                ll = line.split()
                dirs.append(ll[0])
                cats.append(ll[1])

        for c in set(cats):
            out_dir = os.path.join(cat_dir,c)
            if not os.path.isdir(out_dir):
                os.mkdir(out_dir)
            idx = list()
            for cc in cats:
                idx+=[cc==c,cc==c]

            idx = np.array(idx,dtype=bool)
            copyfolder_idx(os.path.join(path,"all_spindle"),out_dir,idx)
            copyfolder_idx(os.path.join(path, "all_dots"), out_dir, idx)
            copyfolder_idx(os.path.join(path, "all_ios"), out_dir, idx)
            # subsection_colfile("all_ios/ios_len_tot.txt", [0, 1])
            # if os.path.isdir()


    return

if __name__ == "__main__":
    if len(sys.argv) < 2:
        main(['.'])
    else:
        main(sys.argv[1:])
