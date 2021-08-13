function output = convertVelToRho(inputField,correctSize,u_or_v,sizeDims)

if sizeDims==2; 
	if strcmp(u_or_v,'u')
		outputTemp=(inputField(1:end-1,2:end-1)+inputField(2:end,2:end-1))./2;
		output = nan([correctSize]);
		output(2:end-1,2:end-1)=outputTemp;
	elseif strcmp(u_or_v,'v')
		outputTemp=(inputField(2:end-1,1:end-1)+inputField(2:end-1,2:end))./2;
		output = nan([correctSize]);
		output(2:end-1,2:end-1)=outputTemp;
	end
elseif sizeDims==3;
	if strcmp(u_or_v,'u')
        	outputTemp=(inputField(1:end-1,2:end-1,:)+inputField(2:end,2:end-1,:))./2;
	        output = nan([correctSize]);
        	output(2:end-1,2:end-1,:)=outputTemp;
	elseif strcmp(u_or_v,'v')
	        outputTemp=(inputField(2:end-1,1:end-1,:)+inputField(2:end-1,2:end,:))./2;
		output = nan([correctSize]);
	        output(2:end-1,2:end-1,:)=outputTemp;
	end
elseif sizeDims==4;
	if strcmp(u_or_v,'u')
	        outputTemp=(inputField(1:end-1,2:end-1,:,:)+inputField(2:end,2:end-1,:,:))./2;
	        output = nan([correctSize]);
	        output(2:end-1,2:end-1,:,:)=outputTemp;
	elseif strcmp(u_or_v,'v')
	        outputTemp=(inputField(2:end-1,1:end-1,:,:)+inputField(2:end-1,2:end,:,:))./2;
	        output = nan([correctSize]);
        	output(2:end-1,2:end-1,:,:)=outputTemp;
	end
end

