function output = loadTracers(fileName,longrab,latgrab,layergrab,timegrab,tracerName)

output = double(squeeze(ncread(fileName,tracerName,[longrab(1) latgrab(1) layergrab(1) timegrab(1)],[longrab(2)-longrab(1)+1 latgrab(2)-latgrab(1)+1 layergrab(2)-layergrab(1)+1 timegrab(2)-timegrab(1)+1])));

