import matplotlib.pyplot as plt

chrs = {}

with open('diversity_level.windowed.pi', 'r') as f:
    info = f.readlines()

for i in range(2, len(info)):#skip the first line
    linfo = info[i].split("\t")
    if linfo[0] in chrs:
        chrs[linfo[0]][0].append(int(linfo[1]))
        chrs[linfo[0]][1].append(float(linfo[4]))
    else:
        chrs[linfo[0]] = [[] for i in range(2)]

fig = plt.figure()
fig.subplots_adjust(hspace=0.5)

i = 1
nrow = len(chrs)
for chr, data in chrs.items():
    axs = fig.add_subplot(nrow, 1,  i)
    axs.plot(data[0], data[1])
    axs.set_xlabel(chr)
    axs.set_ylabel('pi')
    axs.grid(True)
    i = i + 1

plt.show()
plt.savefig('diversity_plot.png', dpi=300)

