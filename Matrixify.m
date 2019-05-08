function out = Matrixify(in)
    % This function turns the song into a matrix of its subbands
    in = [in, zeros(1,512)];
    % We need extra samples so we can get to the end of the song.
    % We want the amount of samples to be divisible by 32 and 512 so we add
    % these zeros
    C_val = load('C_vals.mat'); 
    % This is the mat file where daniel compiled all the C values
    C = C_val.C';%It comes in as a struct for some reason
    L = length(in);
    if mod(L, 32)%If not divisible by 32
        in = [in, zeros(1, 384-rem(L,384))];
        % This adds some more zeros to the end so its divisble by 32
        L = length(in); %Recomputes length
    end
    buff = zeros(1,512); % we load each set of samples into buff to do math with
    out = zeros(32,L/32); % Preallocates Matrix of output
    Read = zeros(1,32);
    for n = 0:(L/32 - 1)%We deal with 32 smaples at a time
        Read = in(n*32+1:n*32+32);%Reads the next 32 values
        buff = [fliplr(Read), buff(1:end-32)]; % Feeds those 32 values into buffer
        normalized = buff .* C; % C is the magic vector that weights buffer and makes thigns work
        storage = zeros(64,1); 
        for m = 0:7
            storage = storage + normalized( (m*64+1):(m*64+64) )';
            %Picks 64 samples at a time and adds them up
        end
        [k, i] = meshgrid(0:63, 0:31);
        DCT = cos( ( (2*i + 1) .* (k - 16) * pi) / 64);
        % Discrete cosine transform
        out(:,n+1) = DCT * storage;
    end
end

