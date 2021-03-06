function [ grayCode ] = bi2grayCode( txBits, N, numBits )

grayCode = false(numBits,N);

for ii = 1:N
    
    cnt = 1;
    
    while cnt<numBits
        grayCode(1,ii) = txBits(1,ii);
        a = txBits(cnt,ii);
        b = txBits(cnt+1,ii);
        grayCode(cnt+1,ii) = mod(a + b,2);
        cnt= cnt+1;
    end
end

end

