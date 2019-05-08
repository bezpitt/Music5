function out = Songify(in)
    C_val = load('C_vals.mat');
    C = C_val.C';
    Normal = C*32;%This will eventually normalize the data
    Sizze = size(in);
    Amount = Sizze(1) * Sizze(2);
    out = zeros(Amount,1);%Preallocates out
    [k, i] = meshgrid(0:63, 0:31);
    DCT = cos( ( (2*i + 1).*(k + 16)*pi ) / 64);
    %This is the discrete cosine transform
    IDCT = DCT'; % Approximate inverse DCT
    inverted_buff = zeros(64, 16);%Preallocates matrix to which we shove in chunks of the input
    for n = 0:size(in, 2)-1
        inversed = IDCT * in(:,n+1);
        inverted_buff = [inversed, inverted_buff(:,1:end-1)];
        Psuedo_time_domain = zeros(1, 512);%Here we store 512 time samples
        for j = 0:15%Takes samples from inverted buffer and reshuffles them into psuedo_time_domain
            if mod(j, 2) %if odd
                Psuedo_time_domain(j*32+1:j*32+32) = inverted_buff( 33:64, j+1 )';
            else%if even
                Psuedo_time_domain(j*32+1:j*32+32) = inverted_buff( 1:32, j+1 )';
            end
        end
        Normalized_time = Psuedo_time_domain .* Normal; % Normalizes with C values
        time_buff = zeros(32,1);%We add up the psuedo_tim to get real time in the time_buff
        for m = 0:15
            time_buff = time_buff + Normalized_time((m*32+1):(m*32+32))';
        end
        out(n*32+1:n*32+32) = time_buff;
    end
    out = out';
end

