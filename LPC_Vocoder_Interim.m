classdef LPC_Vocoder_Interim < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                        matlab.ui.Figure
        AnalysisPanel                   matlab.ui.container.Panel
        UIAxes2                         matlab.ui.control.UIAxes
        UIAxes3                         matlab.ui.control.UIAxes
        InputPanel                      matlab.ui.container.Panel
        UIAxes                          matlab.ui.control.UIAxes
        ClickhereButtonGroup            matlab.ui.container.ButtonGroup
        RecordButton                    matlab.ui.control.Button
        PlayButton                      matlab.ui.control.Button
        DurationinsecondsTextAreaLabel  matlab.ui.control.Label
        DurationinsecondsTextArea       matlab.ui.control.TextArea
    end

    methods (Access = private)

        % Button pushed function: RecordButton
        function RecordButtonPushed(app, event)
            
            audioObject = audiorecorder;     
            Fs = audioObject.SampleRate;
            duration = str2double(app.DurationinsecondsTextArea.Value{1});
            msgbox('Recording');
            recordblocking(audioObject, duration);
            msgbox('Done');   
            y = getaudiodata(audioObject);
            plot(app.UIAxes, (1/Fs)*(0:length(y)-1), y);
            %plot(app.UIAxes2, spectrogram(y));
            assignin('base', 'audioObject', audioObject);
            
                [s,f,t]=spectrogram(y,hamming(240),120,audioObject.SampleRate);
                mags=s.*conj(s);
                image(app.UIAxes2,f, t, -10.*log10(mags/max(max(mags))));
                set(app.UIAxes2, 'YDir','normal');
                ylim(app.UIAxes2,[t(1) t(end)]);
                xlim(app.UIAxes2,[f(1) f(end)]);
                %colorbar(app.UIAxes2);
                
                reconstructed = y;
                [s,f,t]=spectrogram(reconstructed,hamming(240),120,audioObject.SampleRate);
                mags=s.*conj(s);
                image(app.UIAxes3,f, t, -10.*log10(mags/max(max(mags))));
                set(app.UIAxes3, 'YDir','normal');
                ylim(app.UIAxes3,[t(1) t(end)]);
                xlim(app.UIAxes3,[f(1) f(end)]);
                    
        end

        % Button pushed function: PlayButton
        function PlayButtonPushed(app, event)
            
            audioObject = evalin('base', 'audioObject');
            y = getaudiodata(audioObject);
            Fs = audioObject.SampleRate;
            sound(y, Fs);
         
        end

        % Callback function
        function SwitchValueChanged(app, event)
            
%             audioObject = evalin('base', 'audioObject');
%             y = getaudiodata(audioObject);
%             %Fs = audioObject.SampleRate;
%             value = app.Switch.Value;
%             if(value)
%                 plot(app.UIAxes2, spectrogram(y));
%             else
%                 x = lpc(y);
%                 plot(app.UIAxes2, spectrogram(x));
%             end
                
        end

        % Callback function
        function UpdateButtonValueChanged(app, event)
                                                                
        end

        % Callback function
        function UpdateButtonPushed(app, event)
         
        end
    end

    % App initialization and construction
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure
            app.UIFigure = uifigure;
            app.UIFigure.AutoResizeChildren = 'off';
            app.UIFigure.Position = [100 100 1032 984];
            app.UIFigure.Name = 'UI Figure';
            app.UIFigure.Resize = 'off';

            % Create AnalysisPanel
            app.AnalysisPanel = uipanel(app.UIFigure);
            app.AnalysisPanel.AutoResizeChildren = 'off';
            app.AnalysisPanel.Title = 'Analysis';
            app.AnalysisPanel.Position = [74 17 943 510];

            % Create UIAxes2
            app.UIAxes2 = uiaxes(app.AnalysisPanel);
            title(app.UIAxes2, 'Original audio spectrogram')
            xlabel(app.UIAxes2, 'X')
            ylabel(app.UIAxes2, 'Y')
            app.UIAxes2.PlotBoxAspectRatio = [1 0.728994082840237 0.728994082840237];
            app.UIAxes2.Position = [16 63 473 364];

            % Create UIAxes3
            app.UIAxes3 = uiaxes(app.AnalysisPanel);
            title(app.UIAxes3, 'Reconstructed audio spectrogram')
            xlabel(app.UIAxes3, 'X')
            ylabel(app.UIAxes3, 'Y')
            app.UIAxes3.Position = [479 63 447 364];

            % Create InputPanel
            app.InputPanel = uipanel(app.UIFigure);
            app.InputPanel.AutoResizeChildren = 'off';
            app.InputPanel.Title = 'Input';
            app.InputPanel.Position = [74 541 885 393];

            % Create UIAxes
            app.UIAxes = uiaxes(app.InputPanel);
            title(app.UIAxes, 'Recorded Audio Signal')
            xlabel(app.UIAxes, 'X')
            ylabel(app.UIAxes, 'Y')
            app.UIAxes.Position = [16 20 504 344];

            % Create ClickhereButtonGroup
            app.ClickhereButtonGroup = uibuttongroup(app.InputPanel);
            app.ClickhereButtonGroup.AutoResizeChildren = 'off';
            app.ClickhereButtonGroup.Title = 'Click here';
            app.ClickhereButtonGroup.Position = [655 133 123 126];

            % Create RecordButton
            app.RecordButton = uibutton(app.ClickhereButtonGroup, 'push');
            app.RecordButton.ButtonPushedFcn = createCallbackFcn(app, @RecordButtonPushed, true);
            app.RecordButton.Position = [12 62 100 22];
            app.RecordButton.Text = 'Record';

            % Create PlayButton
            app.PlayButton = uibutton(app.ClickhereButtonGroup, 'push');
            app.PlayButton.ButtonPushedFcn = createCallbackFcn(app, @PlayButtonPushed, true);
            app.PlayButton.Position = [12 23 100 22];
            app.PlayButton.Text = 'Play';

            % Create DurationinsecondsTextAreaLabel
            app.DurationinsecondsTextAreaLabel = uilabel(app.InputPanel);
            app.DurationinsecondsTextAreaLabel.HorizontalAlignment = 'right';
            app.DurationinsecondsTextAreaLabel.Position = [631 288 113 22];
            app.DurationinsecondsTextAreaLabel.Text = 'Duration in seconds';

            % Create DurationinsecondsTextArea
            app.DurationinsecondsTextArea = uitextarea(app.InputPanel);
            app.DurationinsecondsTextArea.HorizontalAlignment = 'center';
            app.DurationinsecondsTextArea.Position = [759 286 43 26];
            app.DurationinsecondsTextArea.Value = {'5'};
        end
    end

    methods (Access = public)

        % Construct app
        function app = LPC_Vocoder_Interim

            % Create and configure components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end