close all
clear all
%Daniel Zuerbig helped me a lot with this
%This just  puts them all in the different bands but from there you could
%quantize each band differently
Sampsize=10^6;
[storm,fs] = audioread('storm.wav');
Storm = storm(1:Sampsize,1)';
Matrix_storm = Matrixify(Storm);
backtostorm = Songify(Matrix_storm);
soundsc( backtostorm, fs )