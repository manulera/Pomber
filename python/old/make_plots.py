import os,sys
from matplotlib import pyplot as plt
import numpy as np
from gather import get_files

def plot_col_pairs(filename,mode=0,units=('','')):
    # load the data
    bigarr = np.genfromtxt(filename,delimiter = ',',dtype = str)
    n = os.path.split(filename)
    
    realname = n[-1]
    if len(n[:-1])==1:
        realpath = (n[-2],)
    else:
        realpath = n[:-1]
    
    realname = realname.split('.')[0]
    plotsdir = os.path.join(os.path.join(*realpath),'plots')

    if not os.path.isdir(plotsdir):
        os.mkdir(plotsdir)

    plt.figure()
    # Substraction since the last line is always left empty (ends up in comma only)
    cols = int((bigarr.shape[1]-1)/2)
    
    for i in range(cols):

        x = [float(j) for j in bigarr[:, 2 * i] if j != '']
        y = [float(j) for j in bigarr[:, 2 * i + 1] if j != '']

        plt.plot(x,y)
        if mode==1:
            plt.xlabel(units[0])
            plt.ylabel(units[1])
            plt.tight_layout()
            plt.savefig(os.path.join(plotsdir,realname + '_plot' + str(i+1) + '.png'))
            plt.cla()
    if mode==0:
        plt.xlabel(units[0])
        plt.ylabel(units[1])
        plt.tight_layout()
        plt.savefig(os.path.join(plotsdir,realname + '_plot.png'))

    plt.close()


def plot_ints(folder,which):

    files = ['absci_int_col_um.txt']
    units = [(' Length ($\mu$m)','Intensity(A.U.)')]

    cells = get_files(folder,'cell')
    for c in cells:
        for i,f in enumerate(files):
            plot_col_pairs(os.path.join(folder,c,which,f),mode=1,units=units[i])

def plot_spindles(folder):

    files = ['sp_t_len.txt','sp_t_dist.txt','sp_len_dist.txt','sp_len_ratiotubulin.txt','sp_len_totaltubulin.txt']
    units = [('Time (s)',' Length ($\mu$m)'),
             ('Time (s)',' Distance between poles($\mu$m)'),
             ('Length ($\mu$m)','Distance between poles($\mu$m)'),
             ('Length ($\mu$m)','Ratio tubulin intensity spindle\nvs. total cell intensity'),
             ('Length ($\mu$m)', 'Total tubulin intensity on spindle')
             ]
    for i in range(len(files)):
        plot_col_pairs(os.path.join(folder,'all_spindle',files[i]),units=units[i])

def plot_dots(folder):
    files = ['t_dist.txt']
    units = [('Time (s)',' Distance between poles($\mu$m)')]
    for i in range(len(files)):
        plot_col_pairs(os.path.join(folder,'all_dots',files[i]),units=units[i])

def plot_ios(folder):
    files = ["ios_len_ratio.txt","ios_len_tot.txt"]
    units = [('Length ($\mu$m)', 'Ratio intensity on spindle\nvs. total cell intensity'),
             ('Length ($\mu$m)', 'Total intensity on spindle')
             ]
    for i in range(len(files)):
        plot_col_pairs(os.path.join(folder, 'all_ios', files[i]), units=units[i])


def main(folders):
    for folder in folders:
        if os.path.isdir(os.path.join(folder,'all_spindle')):
            plot_spindles(folder)
            if os.path.isdir(os.path.join(folder, 'all_ios')):
                plot_ios(folder)
            #plot_ints(folder,'spindle')
        if os.path.isdir(os.path.join(folder,'all_dots')):
            plot_dots(folder)


if __name__ == "__main__":
    if len(sys.argv) < 2:
        main(['.'])
    else:
        main(sys.argv[1:])

