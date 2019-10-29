function [ channels,files,nb_chan,nb_tpoints,nb_z,z_step ] = compiled_run( filename )
    % Initialize empty vars
    channels = [];
    files = [];
    nb_chan = [];
    nb_tpoints = [];
    nb_z = [];
    z_step = [];
    fid = fopen(filename);
    while ~feof(fid)
        cont = fgetl(fid);
        eval(cont) 
    end
    fclose(fid);
end