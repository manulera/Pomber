function varargout = Pomber(varargin)
% POMBER MATLAB code for Pomber.fig
%      POMBER, by itself, creates a new POMBER or raises the existing
%      singleton*.
%
%      H = POMBER returns the handle to a new POMBER or the handle to
%      the existing singleton*.
%
%      POMBER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in POMBER.M with the given input arguments.
%
%      POMBER('Property','Value',...) creates a new POMBER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Pomber_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Pomber_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Pomber

% Last Modified by GUIDE v2.5 06-Nov-2019 18:34:40

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Pomber_OpeningFcn, ...
                   'gui_OutputFcn',  @Pomber_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before Pomber is made visible.
function Pomber_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Pomber (see VARARGIN)

% Choose default command line output for Pomber
handles.output = hObject;
handles = pom_init(handles);
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Pomber wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Pomber_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on slider movement.
function slider_t_Callback(hObject, eventdata, handles)
% hObject    handle to slider_t (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
handles = pom_slider_t(handles);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function slider_t_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_t (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in tog_c1.
function tog_c1_Callback(hObject, eventdata, handles)
% hObject    handle to tog_c1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of tog_c1
set(handles.tog_c2,'Value',0)
if numel(handles.channel_names)>2
    set(handles.tog_c3,'Value',0)
    set(handles.tog_merge,'Value',0)
end

handles.toggled=1;
pom_show(handles)
guidata(hObject, handles);

% --- Executes on button press in tog_c2.
function tog_c2_Callback(hObject, eventdata, handles)
% hObject    handle to tog_c2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of tog_c2
set(handles.tog_c1,'Value',0)
if numel(handles.channel_names)>2
    set(handles.tog_c3,'Value',0)
    set(handles.tog_merge,'Value',0)
end

handles.toggled=2;
pom_show(handles)
guidata(hObject, handles);

% --- Executes on button press in tog_c3.
function tog_c3_Callback(hObject, eventdata, handles)
% hObject    handle to tog_c3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of tog_c3
set(handles.tog_c1,'Value',0)
set(handles.tog_c2,'Value',0)
set(handles.tog_merge,'Value',0)
handles.toggled=3;
pom_show(handles)
guidata(hObject, handles);

% --- Executes on button press in tog_merge.
function tog_merge_Callback(hObject, eventdata, handles)
% hObject    handle to tog_merge (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of tog_merge

set(handles.tog_c1,'Value',0)
set(handles.tog_c2,'Value',0)
set(handles.tog_c3,'Value',0)
handles.toggled=4;
pom_show(handles)
guidata(hObject, handles);

% --- Executes on button press in butt_analyze.
function butt_analyze_Callback(hObject, eventdata, handles)

handles = pom_analyze(handles);
pom_show(handles)
guidata(hObject, handles);

% --- Executes on button press in butt_next.
function butt_next_Callback(hObject, eventdata, handles)
% hObject    handle to butt_next (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = pom_movecell( handles,1 );
pom_show(handles)
guidata(hObject, handles);

% --- Executes on button press in butt_prev.
function butt_prev_Callback(hObject, eventdata, handles)
% hObject    handle to butt_prev (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = pom_movecell( handles,-1 );
pom_show(handles)
guidata(hObject, handles);

% --- Executes on button press in butt_import.
function butt_import_Callback(hObject, eventdata, handles)
% hObject    handle to butt_import (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles=pom_import(handles,true);
% Showing the info of t=1,z=1
if handles.pathfile
    % Only update the handles and show if you have provided a valid path of
    % the video
    pom_show(handles)
    guidata(hObject, handles);
end

% --- Executes on button press in butt_select.
function butt_select_Callback(hObject, eventdata, handles)
% hObject    handle to butt_select (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = pom_selectcell(handles);
guidata(hObject, handles);
pom_show(handles)


% --- Executes on button press in butt_save.
function butt_save_Callback(hObject, eventdata, handles)
% hObject    handle to butt_save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
pom_save(handles)


% --- Executes on button press in butt_load.
function butt_load_Callback(hObject, eventdata, handles)
% hObject    handle to butt_load (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[ handles ] = pom_load(handles);
% In case there was no loading
if isfield(handles,'video')
    pom_show(handles)
end

guidata(hObject, handles);


% --- Executes on button press in butt_resegment.
function butt_resegment_Callback(hObject, eventdata, handles)
% hObject    handle to butt_resegment (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = pom_resegment(handles);
pom_show(handles)
guidata(hObject, handles);


% --- Executes on selection change in pop_c1.
function pop_c1_Callback(hObject, eventdata, handles)
handles = pom_pop_channel( handles,get(hObject,'Value'),1 );
pom_show(handles)
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function pop_c1_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in pop_c2.
function pop_c2_Callback(hObject, eventdata, handles)
handles = pom_pop_channel( handles,get(hObject,'Value'),2 );
pom_show(handles)
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function pop_c2_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in pop_c3.
function pop_c3_Callback(hObject, eventdata, handles)
handles = pom_pop_channel( handles,get(hObject,'Value'),3 );
pom_show(handles)
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function pop_c3_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in pop_ex2.
function pop_ex2_Callback(hObject, eventdata, handles)
% hObject    handle to pop_ex2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pop_ex2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pop_ex2
pom_show(handles)

% --- Executes during object creation, after setting all properties.
function pop_ex2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pop_ex2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in pop_ex1.
function pop_ex1_Callback(hObject, eventdata, handles)
% hObject    handle to pop_ex1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pop_ex1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pop_ex1
pom_show(handles)

% --- Executes during object creation, after setting all properties.
function pop_ex1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pop_ex1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in butt_reanalyze.
function butt_reanalyze_Callback(hObject, eventdata, handles)
% hObject    handle to butt_reanalyze (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = pom_reanalyze(handles);
pom_show(handles)
guidata(hObject, handles);


% --- Executes on button press in butt_export.
function butt_export_Callback(hObject, eventdata, handles)
pom_export(handles)
warndlg('Data succesfully exported')



function ed_resolution_Callback(hObject, eventdata, handles)
handles.im_info.resolution = str2double(get(hObject,'String'));
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function ed_resolution_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_resolution (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in butt_anthis.
function butt_anthis_Callback(hObject, eventdata, handles)
% hObject    handle to butt_anthis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = pom_anthis(handles);
pom_show(handles)
guidata(hObject, handles);


% --- Executes on button press in butt_delete.
function butt_delete_Callback(hObject, eventdata, handles)
% hObject    handle to butt_delete (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = pom_deletecell(handles);
pom_show(handles)
guidata(hObject, handles);


% --- Executes on button press in butt_again.
function butt_again_Callback(hObject, eventdata, handles)
handles = pom_again(handles);
%handles = update_ints(handles);
guidata(hObject, handles);


% --- Executes on slider movement.
function slider_cell_Callback(hObject, eventdata, handles)
handles = pom_slider_cell(handles);
pom_show(handles)
guidata(hObject, handles);



% --- Executes during object creation, after setting all properties.
function slider_cell_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_cell (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on selection change in pop_cell_selection_method.
function pop_cell_selection_method_Callback(hObject, eventdata, handles)
% hObject    handle to pop_cell_selection_method (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pop_cell_selection_method contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pop_cell_selection_method


% --- Executes during object creation, after setting all properties.
function pop_cell_selection_method_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pop_cell_selection_method (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in pop_condition_type.
function pop_condition_type_Callback(hObject, eventdata, handles)
handles = pom_change_cond( handles,get(hObject,'Value'));
pom_show(handles)
guidata(hObject, handles);



% --- Executes during object creation, after setting all properties.
function pop_condition_type_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function int_limit_low_Callback(hObject, eventdata, handles)
handles.im_info.contrast(handles.toggled,1)=str2double(get(hObject,'String'));
if handles.im_info.contrast(handles.toggled,1)>handles.im_info.contrast(handles.toggled,2)
    warndlg('You enter a lower limit higher than the upper')
    return
end
pom_show(handles)
guidata(hObject, handles);
% --- Executes during object creation, after setting all properties.
function int_limit_low_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function int_limit_high_Callback(hObject, eventdata, handles)
handles.im_info.contrast(handles.toggled,2)=str2double(get(hObject,'String'));
if handles.im_info.contrast(handles.toggled,1)>handles.im_info.contrast(handles.toggled,2)
    warndlg('You enter an upper limit lower than the lower limit')
    return
end
pom_show(handles)
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function int_limit_high_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in butt_marksquare.
function butt_marksquare_Callback(hObject, eventdata, handles)
    handles = pom_addsquare(handles);
guidata(hObject, handles);


% --- Executes on button press in tog_fastscroll.
function tog_fastscroll_Callback(hObject, eventdata, handles)
% hObject    handle to tog_fastscroll (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of tog_fastscroll


% --- Executes on button press in butt_stack.
function butt_stack_Callback(hObject, eventdata, handles)
handles = pom_anthis(handles,1);
pom_show(handles)
guidata(hObject, handles);


% --- Executes on button press in button_test.
function button_test_Callback(hObject, eventdata, handles)
pom_export4testEB1(handles);


% --- Executes on button press in butt_change_pos.
function butt_change_pos_Callback(hObject, eventdata, handles)
handles = pom_change_pos(handles);
pom_show(handles);
guidata(hObject, handles);


% --- Executes on button press in butt_drift.
function butt_drift_Callback(hObject, eventdata, handles)
if ~handles.drift_applied
    handles.drift_applied=true;
    handles.video = pom_load_drift(handles,handles.video);
    handles.extra = pom_load_drift(handles,handles.extra);
    pom_show(handles);
else
    warndlg('Drift already applied');
end
guidata(hObject, handles);


% --- Executes on button press in butt_load_categories.
function butt_load_categories_Callback(hObject, eventdata, handles)
handles = pom_load_categories(handles,1);
guidata(hObject, handles);


% --- Executes on button press in butt_load_extra.
function butt_load_extra_Callback(hObject, eventdata, handles)
handles = pom_load_extra(handles);
guidata(hObject, handles);


% --- Executes on button press in butt_show_extra.
function butt_show_extra_Callback(hObject, eventdata, handles)
pom_show_extra(handles);


% --- Executes on button press in butt_measure_int.
function butt_measure_int_Callback(hObject, eventdata, handles)
handles = pom_measure_intensities(handles);
guidata(hObject, handles);
