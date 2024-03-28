function [EffectiveProperty] = FcnEffectiveMediumTheory(Properties, VolumeFractions, CoordinationNumber)
if length(Properties) ~= 2
    warning('Inputs to EffectiveMediumTheory are incorrect');
end
temp = (CoordinationNumber/2 .* VolumeFractions(:,1) - 1) .* Properties(1) + (CoordinationNumber/2 .* VolumeFractions(:,2) - 1) .* Properties(2);
EffectiveProperty = 1 ./ (CoordinationNumber-2) .* (temp + sqrt(temp.*temp + 2*(CoordinationNumber-2) .* Properties(1) .* Properties(2)));
end