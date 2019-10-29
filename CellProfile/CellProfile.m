function varargout = CellProfile(varargin)
% CELLPROFILE MATLAB code for CellProfile.fig
%      CELLPROFILE, by itself, creates a new CELLPROFILE or raises the existing
%      singleton*.
%
%      H = CELLPROFILE returns the handle to a new CELLPROFILE or the handle to
%      the existing singleton*.
%
%      CELLPROFILE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CELLPROFILE.M with the given input arguments.
%
%      CELLPROFILE('Property','Value',...) creates a new CELLPROFILE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before CellProfile_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to CellProfile_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help CellProfile

% Last Modified by GUIDE v2.5 29-Jan-2019 11:59:47

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @CellProfile_OpeningFcn, ...
                   'gui_OutputFcn',  @CellProfile_OutputFcn, ...
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


% --- Executes just before CellProfile is made visible.
function CellProfile_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to CellProfile (see VARARGIN)

% Choose default command line output for CellProfile
handles.output = hObject;
if numel(varargin)==1
    handles = cprof_init(handles,varargin{1});
else
    handles = cprof_init(handles,varargin{1},varargin{2});
end
cprof_show(handles);
guidata(hObject, handles);
% UIWAIT makes CellProfile wait for user response (see UIRESUME)
uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = CellProfile_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
if isfield(handles,'output')
    varargout = {handles.output};
    close
else
    % Return an empty array when you close the function
    varargout = {[]};
end

% --- Executes on button press in butt_prev.
function butt_prev_Callback(hObject, eventdata, handles)

for i = 1:str2double(handles.texted_numadd.String)
    handles = cprof_add(handles,false);
end

cprof_show(handles);
guidata(hObject, handles);

% --- Executes on button press in butt_next.
function butt_next_Callback(hObject, eventdata, handles)

for i = 1:str2double(handles.texted_numadd.String)
    handles = cprof_add(handles,true);
end
cprof_show(handles);
guidata(hObject, handles);

% --- Executes on button press in butt_correct.
function butt_correct_Callback(hObject, eventdata, handles)

handles = cprof_correct( handles );
cprof_show(handles);
guidata(hObject, handles);


% --- Executes on button press in butt_copy.
function butt_copy_Callback(hObject, eventdata, handles)

handles = cprof_copy(handles);
cprof_show(handles);
guidata(hObject, handles);

% --- Executes on button press in butt_done.
function butt_done_Callback(hObject, eventdata, handles)
handles.output = cprof_done( handles );
uiresume(handles.figure1);
guidata(hObject, handles);



% --- Executes on button press in butt_restart.
function butt_restart_Callback(hObject, eventdata, handles)
handles = cprof_init(handles,handles.restore);
cprof_show(handles);
guidata(hObject, handles);


% --- Executes on button press in butt_delete.
function butt_delete_Callback(hObject, eventdata, handles)
[ handles ] = cprof_remove( handles );
cprof_show(handles);
guidata(hObject, handles);

% --- Executes on button press in butt_draw.
function butt_draw_Callback(hObject, eventdata, handles)
handles = cprof_draw(handles);
cprof_show(handles);
guidata(hObject, handles);

% --- Executes on button press in butt_horiz.
function butt_horiz_Callback(hObject, eventdata, handles)
handles = cprof_omit(handles,1);
cprof_show(handles);
guidata(hObject, handles);


% --- Executes on button press in butt_vert.
function butt_vert_Callback(hObject, eventdata, handles)
handles = cprof_omit(handles,0);
cprof_show(handles);
guidata(hObject, handles);


% --- Executes on button press in butt_retry.
function butt_retry_Callback(hObject, eventdata, handles)
% hObject    handle to butt_retry (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = cprof_retry( handles );
cprof_show(handles);
guidata(hObject, handles);


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1

guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function texted_numadd_Callback(hObject, eventdata, handles)
% hObject    handle to texted_numadd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of texted_numadd as text
%        str2double(get(hObject,'String')) returns contents of texted_numadd as a double


% --- Executes during object creation, after setting all properties.
function texted_numadd_CreateFcn(hObject, eventdata, handles)
% hObject    handle to texted_numadd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in butt_cellmoves.
function butt_cellmoves_Callback(hObject, eventdata, handles)
% hObject    handle to butt_cellmoves (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = cprof_cellmoves( handles );
cprof_show(handles);
guidata(hObject, handles);


% --- Executes on slider movement.
function slider_main_Callback(hObject, eventdata, handles)

handles.current= round(get(hObject,'Value'));
cprof_show(handles);

guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function slider_main_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_main (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in butt_delete_fist.
function butt_delete_fist_Callback(hObject, eventdata, handles)
% hObject    handle to butt_delete_fist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = cprof_remove(handles,1);
handles.current = numel(handles.list)-handles.limshow + 1;
cprof_show(handles);
guidata(hObject, handles);



% --- Executes on button press in butt_delete_last.
function butt_delete_last_Callback(hObject, eventdata, handles)
% hObject    handle to butt_delete_last (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = cprof_remove(handles,numel(handles.list));
handles.current = 1;
cprof_show(handles);
guidata(hObject, handles);
