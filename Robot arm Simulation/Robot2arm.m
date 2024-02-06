%% By Ali Almorshdy
%The Simple Robotics Simulation app will allow users to input the lengths of two links and observe the robot's motion over a specified simulation time
% two arm draw an ellipse  
classdef Robot2arm < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure          matlab.ui.Figure
        onoffSwitch       matlab.ui.control.Switch
        onoffSwitchLabel  matlab.ui.control.Label
        L2EditField       matlab.ui.control.NumericEditField
        L2EditFieldLabel  matlab.ui.control.Label
        L1EditField       matlab.ui.control.NumericEditField
        L1EditFieldLabel  matlab.ui.control.Label
        SimulateButton    matlab.ui.control.Button
        UIAxes            matlab.ui.control.UIAxes
    end

    % Callbacks that handle component events
    methods (Access = private)

        % Button pushed function: SimulateButton
        function SimulateButtonPushed(app, ~)
            app.onoffSwitch.Value='On';
            hold(app.UIAxes,'off')
            l1=app.L1EditField.Value; %% length of first arm
            l2=app.L2EditField.Value; %% length of second arm
            cla(app.UIAxes)
            theta1 =  readmatrix('theta1.csv');
            theta2 =  readmatrix('theta2.csv');
            X1 = l1 .* cosd(theta1);
            X2 = l1 .* cosd(theta1) + l2 .* cosd(theta1 + theta2);
            Y1 = l1 .* sind(theta1);
            Y2 = l1 .* sind(theta1) + l2 .* sind(theta1 + theta2);

            P1=plot(app.UIAxes,[0,X1(1)],[0,Y1(1)],'r','LineWidth',3);
            P2=plot(app.UIAxes,[X1(1),X2(1)],[Y1(1),Y2(1)],'b','LineWidth',3);
            P3=scatter(app.UIAxes,X2(1),Y2(1),'O','k','filled');
            hold(app.UIAxes,'on')
            try
                while app.onoffSwitch.Value=="On"
                    i=1;
                    while i<=length(theta1) && app.onoffSwitch.Value=="On"

                        delete(P1) ;     delete(P2) ;    delete(P3);
                        P1=plot(app.UIAxes,[0,X1(i)],[0,Y1(i)],'r','LineWidth',3);
                        P2=plot(app.UIAxes,[X1(i),X2(i)],[Y1(i),Y2(i)],'b','LineWidth',3);
                        P3=scatter(app.UIAxes,X2(i),Y2(i),'O','k','filled');
                        drawnow
                        xlim(app.UIAxes,[-max([l1,l2]*2),max([l1,l2])*2])
                        ylim(app.UIAxes,[-max([l1,l2]*2),max([l1,l2])*2])
                        pause(0.4)
                        i=i+9;


                    end
                end
            catch
            end

        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 640 480];
            app.UIFigure.Name = 'Robot Arm Simulation app';

            % Create UIAxes
            app.UIAxes = uiaxes(app.UIFigure);
            title(app.UIAxes, 'Simple Robtics Simulations')
            xlabel(app.UIAxes, 'X')
            ylabel(app.UIAxes, 'Y')
            zlabel(app.UIAxes, 'Z')
            app.UIAxes.GridColor = [1 0 0];
            app.UIAxes.XGrid = 'on';
            app.UIAxes.YGrid = 'on';
            app.UIAxes.Position = [46 89 556 353];

            % Create SimulateButton
            app.SimulateButton = uibutton(app.UIFigure, 'push');
            app.SimulateButton.ButtonPushedFcn = createCallbackFcn(app, @SimulateButtonPushed, true);
            app.SimulateButton.Position = [156 22 100 23];
            app.SimulateButton.Text = 'Simulate';

            % Create L1EditFieldLabel
            app.L1EditFieldLabel = uilabel(app.UIFigure);
            app.L1EditFieldLabel.HorizontalAlignment = 'right';
            app.L1EditFieldLabel.Position = [281 22 25 22];
            app.L1EditFieldLabel.Text = 'L1';

            % Create L1EditField
            app.L1EditField = uieditfield(app.UIFigure, 'numeric');
            app.L1EditField.Position = [321 22 100 22];
            app.L1EditField.Value = 10;

            % Create L2EditFieldLabel
            app.L2EditFieldLabel = uilabel(app.UIFigure);
            app.L2EditFieldLabel.HorizontalAlignment = 'right';
            app.L2EditFieldLabel.Position = [449 23 25 22];
            app.L2EditFieldLabel.Text = 'L2';

            % Create L2EditField
            app.L2EditField = uieditfield(app.UIFigure, 'numeric');
            app.L2EditField.Position = [489 23 100 22];
            app.L2EditField.Value = 7;

            % Create onoffSwitchLabel
            app.onoffSwitchLabel = uilabel(app.UIFigure);
            app.onoffSwitchLabel.HorizontalAlignment = 'center';
            app.onoffSwitchLabel.Position = [63 1 35 22];
            app.onoffSwitchLabel.Text = 'on-off';

            % Create onoffSwitch
            app.onoffSwitch = uiswitch(app.UIFigure, 'slider');
            app.onoffSwitch.Position = [57 38 45 20];
            app.onoffSwitch.Value = 'On';

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = Robot2arm

            % Create UIFigure and components
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