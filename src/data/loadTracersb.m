function output = loadTracersb(TfileName,SfileName,longrab,latgrab,timegrab)
MaskFile='../data/proc/mask_totten.nc';

Tb = double(ncread(TfileName,'Tb',[longrab(1) latgrab(1) timegrab(1)],[longrab(2)-longrab(1)+1 latgrab(2)-latgrab(1)+1 timegrab(2)-timegrab(1)+1]));
Sb = double(ncread(SfileName,'Sb',[longrab(1) latgrab(1) timegrab(1)],[longrab(2)-longrab(1)+1 latgrab(2)-latgrab(1)+1 timegrab(2)-timegrab(1)+1]));

output.Tb = Tb;
output.Sb = Sb;
