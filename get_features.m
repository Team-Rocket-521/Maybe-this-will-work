function [features] = get_features(clean_data,fs)
    %
    % get_features_release.m
    %
    % Instructions: Write a function to calculate features.
    %               Please create 4 OR MORE different features for each channel.
    %               Some of these features can be of the same type (for example, 
    %               power in different frequency bands, etc) but you should
    %               have at least 2 different types of features as well
    %               (Such as frequency dependent, signal morphology, etc.)
    %               Feel free to use features you have seen before in this
    %               class, features that have been used in the literature
    %               for similar problems, or design your own!
    %
    % Input:    clean_data: (samples x channels)
    %           fs:         sampling frequency
    %
    % Output:   features:   (1 x (channels*features))
    % 
%% Your code here (8 points)
% Line-Length
u=size(clean_data);
u=u(1);
features=zeros(u,6);
    features(1)=mean(clean_data);
    features(2)=bandpower(clean_data,fs,[5 15]);
    features(3)=bandpower(clean_data,fs,[20 25]);
    features(4)=bandpower(clean_data,fs,[75 115]);
    features(5)=bandpower(clean_data,fs,[125 160]);
    features(6)=bandpower(clean_data,fs,[160 175]);

