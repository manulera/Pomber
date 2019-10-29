function [ stage_names, nb_z,wave_names,skipped_wavelength ] = ReadndFile( direc,ndfile )
    
    
    fid = fopen([direc filesep ndfile],'r');
    
    stage_names = {};
    wave_names = {};
    nb_z = [];
    skipped_wavelength = [];
    while ~feof(fid)
        cont = fgetl(fid);
        if numel(cont)>6 && strcmp(cont(1:6),'"Stage')
            str_list = split(cont,',');
            stage_names = [stage_names str_list{2}(3:end-1)];
        elseif ~isempty(strfind(cont,'WaveDoZ'))
            nb_z = [nb_z ~isempty(strfind(cont,'TRUE'))];
        elseif ~isempty(strfind(cont,'NZSteps'))
            str_list = split(cont,',');
            nb_z = nb_z * str2double(str_list{2});
        elseif ~isempty(strfind(cont,'WaveName'))
            str_list = split(cont,',');
            wave_names = [wave_names str_list{2}(3:end-1)];
        elseif numel(cont)>21 && strcmp(cont(1:21),'"WavePointsCollected"')
            % Some time points are skipped in certain wavelengths
            str_list = split(cont,',');
            skipped_wavelength = [skipped_wavelength str2num(str_list{2})];
        end
    end
    nb_z(nb_z==0)=1;
    fclose(fid);
end

