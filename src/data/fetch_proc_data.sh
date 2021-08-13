#!/bin/bash


remoteDir='/g/data/gh9/deg581/ana/tisom017_sgfw/'
localDir='../../data/proc/.'

rsync --progress -avz deg581@gadi-dm.nci.org.au:${remoteDir}/tisom017_sgfw_*_m_yr0021-0025_monmean.nc ${localDir};
rsync --progress -avz deg581@gadi-dm.nci.org.au:${remoteDir}/tisom017_sgfw_SpinUp_m_yr0001-0020_monmean.nc ${localDir};
rsync --progress -avz deg581@gadi-dm.nci.org.au:${remoteDir}/tisom017_sgfw_*_m_yr0021-0021.nc ${localDir};
rsync --progress -avz deg581@gadi-dm.nci.org.au:${remoteDir}/tisom017_sgfw_Norm_*_m_yr0021-0021.nc ${localDir};
rsync --progress -avz deg581@gadi-dm.nci.org.au:${remoteDir}/tisom017_sgfw_*_*_yr0021-0021.nc ${localDir};
exit




