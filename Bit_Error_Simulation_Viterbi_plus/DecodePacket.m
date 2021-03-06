function [ decodedMsg ] = DecodePacket( Decision, Value, PreviousState ,Decode, stages, BranchNum, TxPacket )
% DecodePacket
%
% This function determines the most likely path through the trellis map,
% returns the decoded message
%
% Usage :
%
% [ decodedMsg ] = DecodePacket( Decision, Value, PreviousState ,Decode,
% stages )
%
% Where         Decision        = Hard of Soft Decision
%
%				Value           = Trellis values 
%
%				PreviousState   = States for Trellis map
%
%				Decode          = Possible decoded states and each stage
%
%				stages          = Number of stages


switch Decision
    case 'HardDecision'
        decodedMsg = NaN(1, stages-1);
        SurviverPath = NaN(1, stages-1);
        SurviverDecode = NaN(1, stages-1);
        SurviverPath(1, stages-1)= PreviousState(1,stages); % associated previous states and decoded value
        SurviverDecode(1, stages-1) = Decode(1,stages);
        decodedMsg(1, stages-1) = SurviverDecode(1, stages-1);
        for i = stages-1:-1:2
%             [maxValue1, stateIndex1] = min(Value(SurviverPath(1, i),i));
            [maxValue, stateIndex] = min(Value(:,i));       % Determines the maximum value at each stage and finds
            SurviverPath(i-1)= PreviousState(stateIndex,i); % associated previous states and decoded value
            SurviverDecode(i-1) = Decode(stateIndex,i);
            decodedMsg(i-1) = SurviverDecode(i-1);
        end
        
%         decodedMsg = NaN(1, stages-1);
%         SurviverPath = NaN(1, stages-1);
%         SurviverDecode = NaN(1, stages-1);
%         for i = stages:-1:2
%             [minValue, stateIndex] = min(Value(:,i));       % Determines the minimum value at each stage and finds
%             SurviverPath(i-1)= PreviousState(stateIndex,i); % associated previous states and decoded value
%             SurviverDecode(i-1) = Decode(stateIndex,i);
%             decodedMsg(i-1) = SurviverDecode(i-1);
%         end
    case 'SoftDecision'
%             n = 5:30;
%             Pass =zeros(1,length(n));
%             for j = 1:length(n)
%                 decodedMsg = NaN(1, n(j));
%                 SurviverPath = NaN(1, n(j));
%                 SurviverDecode = NaN(1, n(j));
%                 
%                 SurviverPath(n(j))= PreviousState(1,stages); % associated previous states and decoded value
%                 SurviverDecode(n(j)) = Decode(1,stages);
%                 decodedMsg(n(j)) = SurviverDecode(n(j));
%                 count = 1;
%                 for i = stages-2:-1:stages-(n(j))
%                     [maxValue, stateIndex] = max(Value(:,i));       % Determines the maximum value at each stage and finds
%                     SurviverPath(n(j)-count)= PreviousState(stateIndex,i); % associated previous states and decoded value
%                     SurviverDecode(n(j)-count) = Decode(stateIndex,i);
%                     decodedMsg(n(j)-count) = SurviverDecode(n(j)-count);
%                     count = count+1;
%                 end
%                 if sum(TxPacket(end:-1:end-n(j)+1)~=decodedMsg)>0
%                     Pass(j)= 1;
%                 end
%             end
% 
%             plot(n,Pass)
        decodedMsg = NaN(1, stages-1);
        SurviverPath = NaN(1, stages-1);
        SurviverDecode = NaN(1, stages-1);
        SurviverPath(1, stages-1)= PreviousState(1,stages); % associated previous states and decoded value
        SurviverDecode(1, stages-1) = Decode(1,stages);
        decodedMsg(1, stages-1) = SurviverDecode(1, stages-1);
        ConstraintLength = 6;
        TracebackLength = ConstraintLength*5;
        for i = stages-1:-1:stages-1-TracebackLength
%            [maxValue1, stateIndex1] = max(Value(SurviverPath(1, i),i));
            [maxValue, stateIndex] = max(Value(:,i));       % Determines the maximum value at each stage and finds
            SurviverPath(i-1)= PreviousState(stateIndex,i); % associated previous states and decoded value
            SurviverDecode(i-1) = Decode(stateIndex,i);
            decodedMsg(i-1) = SurviverDecode(i-1);
        end
%         for i = stages-1:-1:2
% %             [maxValue1, stateIndex1] = max(Value(SurviverPath(1, i),i));
%             [maxValue, stateIndex] = max(Value(:,i));       % Determines the maximum value at each stage and finds
%             SurviverPath(i-1)= PreviousState(stateIndex,i); % associated previous states and decoded value
%             SurviverDecode(i-1) = Decode(stateIndex,i);
%             decodedMsg(i-1) = SurviverDecode(i-1);
%         end
end
end

  
            