import os
import sys

import numpy as np
from matplotlib import pyplot as plt
import os
from gather import get_files
from collections import OrderedDict


def unique_legend():
    handles, labels = plt.gca().get_legend_handles_labels()
    by_label = OrderedDict(zip(labels, handles))
    plt.legend(by_label.values(), by_label.keys())

def get_order(folder):

    out = list()
    if type(folder)==str:
        with open(os.path.join(folder,'order.txt')) as ins:
            for line in ins:
                out.append(line.strip())
    else:
        for c in folder:
            out.append(get_order(os.path.join(c.folder)))
    return out


def plot_col_pairs(filename,mode=0,units=('',''),config=False,names=list()):
    # load the data
    the_dict = dict()
    kwargs = {}
    if type(config)==Config:
        kwargs.update({'label': config.name, 'color' : config.color})

    bigarr = np.genfromtxt(filename,delimiter = ',',dtype = str)
    n = os.path.split(filename)
    
    realname = n[-1]
    if len(n[:-1])==1:
        realpath = (n[-2],)
    else:
        realpath = n[:-1]

    plotsdir = os.path.join(os.path.join(*realpath),'plots')

    if not os.path.isdir(plotsdir):
        os.mkdir(plotsdir)


    # Substraction since the last line is always left empty (ends up in comma only)
    if bigarr[0,-1]=="":
        cols = int((bigarr.shape[1] - 1) / 2)
    else:
        cols = int((bigarr.shape[1]) / 2)
    print cols
    for i in range(cols):

        x = [float(j) for j in bigarr[:, 2 * i] if j != '']
        y = [float(j) for j in bigarr[:, 2 * i + 1] if j != '']

        out = plt.plot(x,y, picker=1,**kwargs)
        if len(names):

            the_dict.update({out[0]: names[i]})
        if mode==1:
            plt.xlabel(units[0])
            plt.ylabel(units[1])
            plt.tight_layout()
            plt.savefig(os.path.join(plotsdir,realname + '_plot' + str(i+1) + '.png'))
            plt.cla()
    if mode==0:
        plt.legend(loc="best")
        plt.xlabel(units[0])
        plt.ylabel(units[1])
        plt.tight_layout()
        plt.savefig(os.path.join(plotsdir,realname + '_plot.png'))
    return the_dict

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


    if type(folder) ==str:
        for i in range(len(files)):

            plot_col_pairs(os.path.join(folder,'all_spindle',files[i]),units=units[i])
            plt.close()
    # in case they are a list of config

    elif type(folder) == list:
        order = get_order(folder)

        label_dic = dict()
        for i in range(len(files)):
            f = plt.figure()

            for ii,c in enumerate(folder):
                label_dic.update(plot_col_pairs(os.path.join(c.folder,'all_spindle',files[i]),units=units[i],config=c,names=order[ii]))

            # Combine all lists to make an index of the folders

            def onpick(event):

                thisline = event.artist

                thisline._color="cyan"
                ind = event.ind[0]

                if label_dic.get(thisline):
                    x = thisline.get_xdata()
                    y = thisline.get_ydata()
                    name = label_dic[thisline]
                    plt.annotate(name, xy=(x[ind], y[ind]), xytext=(0, 0), textcoords="offset points",
                                bbox=dict(boxstyle="round", fc="w"),
                                arrowprops=dict(arrowstyle="->"))

                plt.draw()
            f.canvas.mpl_connect('pick_event', onpick)

            unique_legend()
            plt.savefig(files[i].split('.')[0] + "_plot.png")
            plt.savefig(files[i].split('.')[0] + "_plot.eps")

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

class Config(object):
    def __init__(self):
        self.folder=False
        self.color = None
        self.name = None
    def __nonzero__(self):
        return self.folder==True
def get_plot_config(folder):
    all_conf = list()
    with open(folder) as ins:
        for line in ins:
            if len(line):
                ls = line.split("-")
                if len(ls)>1:
                    ls[0] = ls[0].strip()
                    if ls[0]=="folder":
                        conf = Config()
                        all_conf.append(conf)
                        conf.folder = ls[1].strip()
                    elif ls[0]=="color":
                        if len(all_conf)==0:
                            os.error("You must define a folder before giving the options")
                        conf.color = ls[1].strip()
                    elif ls[0] == "name":
                        if len(all_conf)==0:
                            os.error("You must define a folder before giving the options")
                        conf.name = ls[1].strip()
    return all_conf

def plot_with_config(all_conf):
    if all([os.path.isdir(os.path.join(c.folder, 'all_spindle')) for c in all_conf]):
        plot_spindles(all_conf)
        # for c in all_conf:
        #     plot_spindles(folder)


def main(folders):
    for folder in folders:
        if os.path.isfile(os.path.join(folder,'plot_instructions.txt')):
            all_config = get_plot_config(os.path.join(folder,'plot_instructions.txt'))
            plot_with_config(all_config)
            return

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
        plt.show()
    else:
        main(sys.argv[1:])

