function output = loadTracers(TfileName,SfileName,longrab,latgrab,layergrab,timegrab)
MaskFile='../data/proc/mask_totten.nc';

temp = double(squeeze(ncread(TfileName,'temp',[longrab(1) latgrab(1) layergrab(1) timegrab(1)],[longrab(2)-longrab(1)+1 latgrab(2)-latgrab(1)+1 layergrab(2)-layergrab(1)+1 timegrab(2)-timegrab(1)+1])));
salt = double(squeeze(ncread(SfileName,'salt',[longrab(1) latgrab(1) layergrab(1) timegrab(1)],[longrab(2)-longrab(1)+1 latgrab(2)-latgrab(1)+1 layergrab(2)-layergrab(1)+1 timegrab(2)-timegrab(1)+1])));

output.T = temp;
output.S = salt;
