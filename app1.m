classdef app1 < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                 matlab.ui.Figure
        Panel                    matlab.ui.container.Panel
        TemizleButton            matlab.ui.control.Button
        EditField_6              matlab.ui.control.EditField
        EditField_5              matlab.ui.control.EditField
        EditField_4              matlab.ui.control.EditField
        EditField_3              matlab.ui.control.EditField
        EditField_2              matlab.ui.control.EditField
        ceyreklikLabel_2         matlab.ui.control.Label
        medyanLabel              matlab.ui.control.Label
        ceyreklikLabel           matlab.ui.control.Label
        varyansLabel             matlab.ui.control.Label
        orneklemortalamasiLabel  matlab.ui.control.Label
        HesaplaButton            matlab.ui.control.Button
        EditField                matlab.ui.control.EditField
        veriyigirinizLabel       matlab.ui.control.Label
    end

    % Callbacks that handle component events
    methods (Access = private)

        % Button pushed function: HesaplaButton
        function HesaplaButtonPushed(app, event)
            % 1. Veriyi Al ve Sayısal Vektöre Çevir
    strData = app.EditField.Value; % Kullanıcının girdiği metin
    x = str2num(strData); % Metni sayı dizisine çevir (örn: [1 5 10])
    
    if isempty(x)
        uialert(app.UIFigure, 'Lütfen geçerli bir veri giriniz!', 'Hata');
        return;
    end
    
    n = length(x);
    
    % 2. Ortalama Hesaplama (Hazır komutsuz: sum(x)/n)
    toplam = 0;
    for i = 1:n
        toplam = toplam + x(i);
    end
    ort = toplam / n;
    
    % 3. Varyans Hesaplama (Hazır komutsuz: sum((x-ort)^2)/(n-1))
    kareToplam = 0;
    for i = 1:n
        kareToplam = kareToplam + (x(i) - ort)^2;
    end
    varyans = kareToplam / (n - 1);
    
    % 4. Çeyreklikler ve Medyan İçin Veriyi Sırala (Hazır komutsuz - Bubble Sort)
    xs = x;
    for i = 1:n-1
        for j = 1:n-i
            if xs(j) > xs(j+1)
                gecici = xs(j);
                xs(j) = xs(j+1);
                xs(j+1) = gecici;
            end
        end
    end
    
    % 5. Medyan ve Çeyreklik Hesaplama Fonksiyonu (Interpolation-based)
    function val = hesaplaYuzdelik(data, p, len)
        index = p * (len + 1);
        k = floor(index);
        d = index - k;
        if k < 1
            val = data(1);
        elseif k >= len
            val = data(len);
        else
            val = data(k) + d * (data(k+1) - data(k));
        end
    end

    c1 = hesaplaYuzdelik(xs, 0.25, n); % 1. Çeyreklik
    med = hesaplaYuzdelik(xs, 0.50, n); % Medyan
    c3 = hesaplaYuzdelik(xs, 0.75, n); % 3. Çeyreklik
    
    % 6. Sonuçları Arayüze Yazdır
    app.EditField_2.Value = num2str(ort);     % Ortalama
    app.EditField_3.Value = num2str(varyans); % Varyans
    app.EditField_4.Value = num2str(c1);      % 1. Çeyreklik
    app.EditField_5.Value = num2str(med);     % Medyan
    app.EditField_6.Value = num2str(c3);      % 3. Çeyreklik
        end

        % Button pushed function: TemizleButton
        function TemizleButtonPushed(app, event)
            app.EditField.Value   = '';
            app.EditField_2.Value = '';
            app.EditField_3.Value = '';
            app.EditField_4.Value = '';
            app.EditField_5.Value = '';
            app.EditField_6.Value = '';

        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 1189 480];
            app.UIFigure.Name = 'MATLAB App';

            % Create Panel
            app.Panel = uipanel(app.UIFigure);
            app.Panel.Title = 'Panel';
            app.Panel.Position = [34 25 1138 437];

            % Create veriyigirinizLabel
            app.veriyigirinizLabel = uilabel(app.Panel);
            app.veriyigirinizLabel.Position = [529 349 68 55];
            app.veriyigirinizLabel.Text = 'veriyi giriniz';

            % Create EditField
            app.EditField = uieditfield(app.Panel, 'text');
            app.EditField.FontColor = [1 1 1];
            app.EditField.Position = [487 303 152 47];

            % Create HesaplaButton
            app.HesaplaButton = uibutton(app.Panel, 'push');
            app.HesaplaButton.ButtonPushedFcn = createCallbackFcn(app, @HesaplaButtonPushed, true);
            app.HesaplaButton.Position = [495 247 136 40];
            app.HesaplaButton.Text = 'Hesapla';

            % Create orneklemortalamasiLabel
            app.orneklemortalamasiLabel = uilabel(app.Panel);
            app.orneklemortalamasiLabel.Position = [57 114 119 26];
            app.orneklemortalamasiLabel.Text = 'orneklem ortalamasi';

            % Create varyansLabel
            app.varyansLabel = uilabel(app.Panel);
            app.varyansLabel.Position = [308 114 68 26];
            app.varyansLabel.Text = 'varyans';

            % Create ceyreklikLabel
            app.ceyreklikLabel = uilabel(app.Panel);
            app.ceyreklikLabel.Position = [520 114 68 26];
            app.ceyreklikLabel.Text = '1.ceyreklik';

            % Create medyanLabel
            app.medyanLabel = uilabel(app.Panel);
            app.medyanLabel.Position = [760 114 68 26];
            app.medyanLabel.Text = 'medyan';

            % Create ceyreklikLabel_2
            app.ceyreklikLabel_2 = uilabel(app.Panel);
            app.ceyreklikLabel_2.Position = [973 114 68 26];
            app.ceyreklikLabel_2.Text = '3.ceyreklik';

            % Create EditField_2
            app.EditField_2 = uieditfield(app.Panel, 'text');
            app.EditField_2.Position = [57 75 119 32];

            % Create EditField_3
            app.EditField_3 = uieditfield(app.Panel, 'text');
            app.EditField_3.Position = [271 75 119 32];

            % Create EditField_4
            app.EditField_4 = uieditfield(app.Panel, 'text');
            app.EditField_4.Position = [501 75 119 32];

            % Create EditField_5
            app.EditField_5 = uieditfield(app.Panel, 'text');
            app.EditField_5.Position = [734 75 119 32];

            % Create EditField_6
            app.EditField_6 = uieditfield(app.Panel, 'text');
            app.EditField_6.Position = [947 75 119 32];

            % Create TemizleButton
            app.TemizleButton = uibutton(app.Panel, 'push');
            app.TemizleButton.ButtonPushedFcn = createCallbackFcn(app, @TemizleButtonPushed, true);
            app.TemizleButton.Position = [495 177 136 40];
            app.TemizleButton.Text = 'Temizle';

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = app1

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