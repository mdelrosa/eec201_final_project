function varargout = LPC_Vocoder(varargin)
% BASIC MATLAB code for Basic.fig
%      BASIC, by itself, creates a new BASIC or raises the existing
%      singleton*.
%
%      H = BASIC returns the handle to a new BASIC or the handle to
%      the existing singleton*.
%
%      BASIC('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in BASIC.M with the given input arguments.
%
%      BASIC('Property','Value',...) creates a new BASIC or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Basic_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Basic_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Basic

% Last Modified by GUIDE v2.5 21-Feb-2019 21:16:40

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Basic_OpeningFcn, ...
                   'gui_OutputFcn',  @Basic_OutputFcn, ...
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


% --- Executes just before Basic is made visible.
function Basic_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Basic (see VARARGIN)

handles.recordObj = audiorecorder(44100,16,2); % init audiorecorder at 44.1kHz, 16-bit depth, 2-channel (stereo)

% handles.currentData = handles.peaks;
% surf(handles.currentData);

% Choose default command line output for Basic
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Basic wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Basic_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1
guidata(hObject,handles);

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

% --- Executes on button press in record_toggle.
function record_toggle_Callback(hObject, eventdata, handles)
% hObject    handle to record_toggle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of record_toggle
bool=get(hObject,'Value');
if(bool)
    set(handles.record_toggle, 'String', 'Recording');
    set(handles.record_toggle, 'BackgroundColor', [1 0 0]);
    record(handles.recordObj);
else
    set(handles.record_toggle, 'String', 'Record');
    set(handles.record_toggle, 'BackgroundColor', [.94 .94 .94]);
    stop(handles.recordObj);
    handles.audioData=audioplayer(handles.recordObj);
    plot(getaudiodata(handles.recordObj));
end
drawnow;
% Update handles structure
guidata(hObject, handles);

% --- Executes on button press in play_toggle.
function play_toggle_Callback(hObject, eventdata, handles)
% hObject    handle to play_toggle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
bool=get(hObject,'Value');
if(bool)
    set(handles.play_toggle, 'String', 'Playing');
    set(handles.play_toggle, 'BackgroundColor', [0 1 0]);
    stop(handles.audioData);
    playblocking(handles.audioData);
    set(handles.play_toggle, 'String', 'Play');
    set(handles.play_toggle, 'BackgroundColor', [.94 .94 .94]);
end
% Update handles structure
guidata(hObject, handles);