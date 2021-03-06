clear all
close all
parity = 'gCRC8';
codingRate = 1/3;
codingChange = (1/2);
groupBits = 4;

genPoly1 = [1 0 1 1 0 1 1 1 1];
genPoly2 = [1 1 0 1 1 0 0 1 1];
genPoly3 = [1 1 1 1 0 1 0 1 1];

genPoly = [genPoly1;genPoly2;genPoly3];

mem = length(genPoly)-1;
ttiIndex = 1;

TTI = ['10 ms' '20 ms' '40 ms' '80 ms'];

c1Array= [1 2 4 8];

InterColumnPermutation{1} = 0;
InterColumnPermutation{2} = [0 1];
InterColumnPermutation{3} = [0 2 1 3];
InterColumnPermutation{4} = [0 4 2 6 1 5 3 7];

C1 = c1Array(ttiIndex);

[ xorIndex, numGenPoly, genPolyElements ] = xorRegister( genPoly );
k = 2;

bitStreamSize = C1*k;
txPacket = (rand(1,bitStreamSize) > 0.5);  
        
% Encode data stream
% ------------------
[ dataStreamcrc ] = crc_TS36212('Transmitter', txPacket, parity);
register = zeros(1,genPolyElements);
[ codeWord, codeWordBlock, nBits, State ] = encodeDataStream( register, dataStreamcrc, xorIndex, numGenPoly, mem, 'Encode Data' );
Xi = length(codeWord);
R1 = Xi/C1;
yi = zeros(R1,C1); % Interleaver
c1Index = 0;
% Create Interleaving Matrix
for i = 0:R1-1
    c1Index = i*C1;
    for ii = 1:C1
        yi(i+1,ii) = codeWord(c1Index+ii);
    end
end

% Use inter column permutation pattern
yi = yi(:,InterColumnPermutation{ttiIndex}+1);
[Yi,Fi ] = size(yi);     % [Number of radio frames, number of bits per frame]
N = Yi;
percentageChange = (codingRate/codingChange);
DelN = round(N*percentageChange);
if percentageChange<=1
    DelN= -DelN;
end
R = mod(DelN,N);
if (R~= 0)&&(2*R<=N)
    q = N/R;
else
    q = N/(R-N);
end
% q is a signed quantity
if mod(q,2) == 0
    qNot = q + gcd(abs(q),Fi)/Fi;
else
    qNot = q;
end
for x = 0:Fi-1
    S(mod(abs(x*qNot),Fi)+1)= round(abs(x*qNot)/Fi);
end
delNi=delN;     % delN for each frame
a = 2;
Xi = N;
% eini = mod((a*S[]*abs(delNi)+1),a*N);
eplus = a*N;
eminus = a*abs(delNi);
% Rate mactching pattern determiation
if delN~=0                  % If delN = 0 then output data of the rate matching is the same as the input data and the rate matching algorithm does not need to be excuted
    e=eini;                 % Inital error between current and desired puncturing ratio
    m=1;                    % Index of current bit
    while(m<=Xi)
        e = e-eminus;       % Update Error
        if e<=0             % Check if bit number m should be punctured
            set bit xim to sigma {0,1};
            e = e+eplus;
        end
        m = m+1;
    end
else
    e = eini;               % Initial error between current and desired puncturing ratio
    m = 1;                  % Index of current bit
    while m <=Xi
        e = e-eminus;       % Update error
        while e<=0          % Check if bit number m should be repeared
            repeat bit xim
            e=e+eplus;      % Update error
        end
        m = m+1;            % Next bit
    end
end
% for delN<0
%     puncture
% end
% otherwise repetition