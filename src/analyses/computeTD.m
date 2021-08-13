function output = computeTD(TfileName,SfileName,grdName,longrab,latgrab,Ngrab,timegrab)

% load TD function (Tb and Sb)
s = loadTracers(TfileName,SfileName,longrab,latgrab,Ngrab,timegrab);

% load zice
zice = ncread(grdName,'zice',[longrab(1) latgrab(1)],[longrab(2)-longrab(1)+1 latgrab(2)-latgrab(1)+1]);

%compute Td
a=-0.0573;
b=0.0832;
c=-7.53e-8;
Pb = sw_pres(-zice,-67)*1e4; %dbar->Pa
Tfp = a*s.S+b+c*Pb;
td = (s.T-Tfp);
%td(isnan(td))=0;

output = td;

