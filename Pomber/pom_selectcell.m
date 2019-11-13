function [ handles ] = pom_selectcell( handles )

DIC = find(handles.an_type==2);
if isempty(DIC)
    warndlg('You must specify which is the DIC channel')
    uiwait
    return
elseif numel(DIC)>1
    warndlg('Only one channel can be specified as DIC')
    uiwait
    return
end

axes(handles.ax_main)
ima = handles.video{DIC}(:,:,handles.currentt);
[x,y] = getpts();
if numel(x)~=2
    return
end
[ima_cropped,self.xlims,self.ylims] = pom_pre_crop_cell(ima,y,x);
[ cropped_mask ] = draw_cell( ima_cropped);
mask1 = false(size(ima));
mask1(self.xlims,self.ylims) = cropped_mask;

out.contrast = handles.im_info.contrast;
out.tlen = handles.tlen;
out.dic = DIC;
out.video = handles.video;
out.masks=mask1;
out.list = handles.currentt;
cprof_output = CellProfile(out);
% If you close without clicking on "done"
if isempty(cprof_output)
    return
end
newcell = cellu(cprof_output.masks,cprof_output.list,handles.an_type);
newcell.findAllFeatures(handles.video,handles.im_info,handles.extra);

handles = pom_addcell( handles, newcell );

handles = pom_analyze(handles);
handles = pom_movecell(handles,0);
end

