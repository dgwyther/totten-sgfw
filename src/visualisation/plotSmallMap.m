function plotSmallMap(coordX,coordY,variable,cont1,cont1Range,cont2,cont2Range)
flat_pcolor(coordX,coordY,variable);
hold on,contour(coordX,coordY,cont1,cont1Range,'k-','linewidth',2) %grounding line
hold on,contour(coordX,coordY,cont2,cont2Range,[-1:1:0],'k:','linewidth',2) %icefront line

