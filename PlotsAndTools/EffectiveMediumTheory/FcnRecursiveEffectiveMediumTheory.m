function [EffectiveProperty] = FcnRecursiveEffectiveMediumTheory(Properties, VolumeFractions, CoordinationNumber)
if length(Properties) <2
    EffectiveProperty = NaN;
elseif length(Properties) == 2
    temp = (CoordinationNumber/2 .* VolumeFractions(:,1) - 1) .* Properties(1) + (CoordinationNumber/2 .* VolumeFractions(:,2) - 1) .* Properties(2);
    EffectiveProperty = 1 ./ (CoordinationNumber-2) .* (temp + sqrt(temp.*temp + 2*(CoordinationNumber-2) .* Properties(1) .* Properties(2)));
else
    TempEffectiveProperties = Properties(1:end-1);
    TempVolumeFractions = VolumeFractions(1:end-1) ./ sum(VolumeFractions(1:end-1));
    TempEffectiveProperty = FcnRecursiveEffectiveMediumTheory(TempEffectiveProperties, TempVolumeFractions, CoordinationNumber);
    TempEffectiveProperties = [TempEffectiveProperty, Properties(end)];
    TempVolumeFractions = [sum(VolumeFractions(1:end)), VolumeFractions(end)];
    TempVolumeFractions = TempVolumeFractions ./ sum(TempVolumeFractions);
    EffectiveProperty = FcnRecursiveEffectiveMediumTheory(TempEffectiveProperties, TempVolumeFractions, CoordinationNumber);
end
end