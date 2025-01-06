import numpy as np
import matplotlib
matplotlib.use('agg')
import matplotlib.pyplot as plt
import xarray as xr

def process_dataset(filepath, start_year, end_year):
    data = xr.open_dataset(filepath)
    data = data.sortby('time')
    data = data.sel(time=slice(str(start_year), str(end_year)))
    unique_times = np.unique(data.time.values)
    return unique_times

filepaths = {
    'BB': '/mnt/storage6/myers/DATA/AZMP/BB_2000-2020.nc',
    'BI': '/mnt/storage6/myers/DATA/AZMP/BI_2000-2019.nc',
    'FC': '/mnt/storage6/myers/DATA/AZMP/FC_2000-2020.nc',
    'MB': '/mnt/storage6/myers/DATA/AZMP/MB_2000-2019.nc',
    'SEGB': '/mnt/storage6/myers/DATA/AZMP/SEGB_2000-2020.nc',
    'SI': '/mnt/storage6/myers/DATA/AZMP/SI_2000-2020.nc',
    'WB': '/mnt/storage6/myers/DATA/AZMP/WB_2000-2020.nc'
}

start_year = 2007
end_year = 2018

times = {section: process_dataset(filepath, start_year, end_year) 
         for section, filepath in filepaths.items()}

sections = ['BI', 'MB', 'SI', 'WB', 'BB', 'FC', 'SEGB']
y_positions = np.arange(1, len(sections) + 1)[::-1]


plt.figure()
for i, section in enumerate(sections):
    marker = 'X' #if section != 'SEGB' else '+'
    size = 5 #if section != 'SEGB' else 8
    plt.scatter(times[section], [y_positions[i]]*len(times[section]), 
                marker=marker, s=size, color='black')

plt.yticks(y_positions, sections, fontsize=14)
plt.xticks(fontsize=14)
plt.xlabel('Years', fontsize=16)
plt.savefig('/mnt/storage6/elena/LAB60/Plots/observations.png',dpi=300, bbox_inches='tight', format='png')

