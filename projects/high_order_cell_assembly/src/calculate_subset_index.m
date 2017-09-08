%!/usr/bin/env python
% ----------------------------------------------------------------------
% Numenta Platform for Intelligent Computing (NuPIC)
% Copyright (C) 2016, Numenta, Inc.  Unless you have an agreement
% with Numenta, Inc., for a separate license for this software code, the
% following terms and conditions apply:
%
% This program is free software: you can redistribute it and/or modify
% it under the terms of the GNU Affero Public License version 3 as
% published by the Free Software Foundation.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
% See the GNU Affero Public License for more details.
%
% You should have received a copy of the GNU Affero Public License
% along with this program.  If not, see http://www.gnu.org/licenses.
%
% http://numenta.org/licenses/
% ----------------------------------------------------------------------

function subsetIndex = calculate_subset_index(spikeMat, numFramesPerStim)
%%
[numNeuron, numFrames] = size(spikeMat);
numRpts = numFrames/numFramesPerStim;

spikeEarly = zeros(numNeuron, numFramesPerStim);
% spikeLate = zeros(numNeuron, numFramesPerStim);

for rep = 1
    spikeEarly = spikeEarly + spikeMat(:, (rep-1)*numFramesPerStim+(1:numFramesPerStim));
end

timeWindow = 1;

spikeEarly = conv2(spikeEarly, ones(1, timeWindow), 'same');
spikeEarly(spikeEarly>0) = 1;

sharedNeuronsAll = [];
numNeuronsLateAll = [];
for rep = 17:20
    spikeLate = spikeMat(:, (rep-1)*numFramesPerStim+(1:numFramesPerStim));
    spikeLate = conv2(spikeLate, ones(1, timeWindow), 'same');
    spikeLate(spikeLate>0) = 1;
    %%
    sharedNeurons = sum(spikeEarly.*spikeLate);
    numNeuronsLate = sum(spikeLate, 1);
    sharedNeuronsAll(end+1) = sum(sharedNeurons);
    numNeuronsLateAll(end+1) = sum(numNeuronsLate);
    
end

    
subsetIndex = sum(sharedNeuronsAll)/sum(numNeuronsLateAll);

    
% %% calculate pairwise subset index
% spikeMatTrials = zeros(numRpts, numNeuron, numFramesPerStim);
% 
% for rep = 1:numRpts
%     spikeMatTrials(rep, :,:) = spikeMat(:, (rep-1)*numFramesPerStim+(1:numFramesPerStim));
% end
% 
% subsetIndex = zeros(20, 20);
% for i = 1:20
%     for j=1:20
%         if i==j
%             continue;
%         end
%         sharedNeurons = sum(squeeze(spikeMatTrials(i, :,:)).*squeeze(spikeMatTrials(j, :,:)));
%         numNeuronsLate = sum(squeeze(spikeMatTrials(j, :,:)), 1);
%         
%         sharedFraction = sharedNeurons./numNeuronsLate;
%         subsetIndex(i, j) = mean(sharedFraction(numNeuronsLate>0));
%         
%     end
% end
