function [linear_fits] = linearFitsSpbsOnly(spb_1,spb_2)
    nb_frames = size(spb_1,1);
    linear_fits = zeros(nb_frames,4);
    for i = 1:nb_frames
        center_between_spbs = (spb_1(i,:) + spb_2(i,:))/2;
        ang=angle2Points(spb_1(i,:),spb_2(i,:));
        linear_fits(i,:) = [ang,center_between_spbs,0];
    end
end

