%% Created by Justin Cooke
% The purpose of this script is to read in csv files created from tecplot
% data of the dune field wall stress. These simulations are continuations
% of those outlined in Cooke, Jerolmack, and Park 2024 
% doi: 10.1073/pnas.2320216121

clc;
clear;
close all;

set(0,'defaultTextInterpreter','latex');

%% Load in the data

% Load in instantaneous wall stress data 
thisInstData = readtable('./Data Files/instantWallStress.csv');

% Load in time-averaged wall stress data (time-averaged over two
% flow-through times)
thisAvgData  = readtable('./Data Files/avg_test.csv');

% Load in wall stress fluctuations (root-mean-square, rms = inst - avg)
thisRmsData  = readtable('./Data Files/rms_test.csv');

%% Clean the data

% Remove the first three columns since they are redundant 

thisInstData(:,1:3) = [];
thisAvgData(:,1:3)  = [];
thisRmsData(:,1:3)  = [];

%% Now sort the data based on x-coordinate (second column)

thisSortedInstData = sortrows(thisInstData,2);
thisSortedAvgData  = sortrows(thisAvgData,2);
thisSortedRmsData  = sortrows(thisRmsData,2);

%% Lastly we will delete the rows corresponding to data we don't care about,
% i.e., in the inflow area where the flow develops, and downstream at the 
% outlet where our numerical sponge BC is located

arrayInstData = table2array(thisSortedInstData);
arrayAvgData  = table2array(thisSortedAvgData);
arrayRmsData  = table2array(thisSortedRmsData);

% Initial Indices for x
iix_Inst = find(arrayInstData(:,2) >= 850,1);
iix_Avg  = find(arrayAvgData(:,2) >= 850,1);
iix_Rms  = find(arrayRmsData(:,2) >= 850,1);

% End Indices for x
iex_Inst = find(arrayInstData(:,2) >= 7850,1);
iex_Avg  = find(arrayAvgData(:,2) >= 7850,1);
iex_Rms  = find(arrayRmsData(:,2) >= 7850,1);

clear i*x_*

%% Isolate the data to what we want

cleanInstData = arrayInstData(iix_Inst:iex_Inst,:);
cleanAvgData  = arrayAvgData(iix_Avg:iex_Avg,:);
cleanRmsData  = arrayRmsData(iix_Rms:iex_Rms,:);


%% Write to csv

writematrix(cleanInstData,'./CleanFiles/Inst_WallStress.dat');
writematrix(cleanAvgData,'./CleanFiles/Avg_WallStress.dat');
writematrix(cleanRmsData,'./CleanFiles/Rms_WallStress.dat');




