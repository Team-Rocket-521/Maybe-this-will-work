function clean_data = filter_data_release(raw_eeg,Hd)
    %
    % filter_data_release.m
    %
    % Instructions: Write a filter function to clean underlying data.
    %               The filter type and parameters are up to you.
    %               Points will be awarded for reasonable filter type,
    %               parameters, and correct application. Please note there 
    %               are many acceptable answers, but make sure you aren't 
    %               throwing out crucial data or adversely distorting the 
    %               underlying data!
    %
    % Input:    raw_eeg (samples x channels)
    %
    % Output:   clean_data (samples x channels)
    % 
%% Your code here (2 points) 
b=reshape(raw_eeg',1,[]);
a=filter(Hd,b);
clean_data=reshape(a,length(raw_eeg),[]);
clean_data=clean_data';


