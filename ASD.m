function [f, asd] = ASD(data, freq)
    % ASD uses fft to compute the amplitude spectral density of the data.
    % "data" should be a collumn vector in the time domain.
    % length(data) must be even.
    data_f = fft(data);
    L = length(data);
    data_f = data_f(1:L/2+1);
    psd = (1/(freq*L)) * abs(data_f).^2;
    psd(2:end-1) = 2*psd(2:end-1);
    asd = sqrt(psd);
    f = freq*(0:(L/2))/L;
end

