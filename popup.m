clc;
clear;

% === STEP 1: Setup Serial Port ===
port = "COM7";       % ✅ Replace with your actual COM port
baudRate = 9600;

s = serialport(port, baudRate);
configureTerminator(s, "LF");
flush(s);

disp("Waiting for START...");
started = false;

% Data buffers
voltage = []; current = []; dod = []; wh = [];
power = []; timeVec = [];

% One-time alert flags
voltageAlertShown = false;
currentAlertShown = false;
dodAlertShown     = false;
powerAlertShown   = false;
whAlertShown      = false;

% Start time
startTime = datetime('now');

% === STEP 2: Create Real-Time Plots ===
figure('Name', 'Battery Telemetry - Real-Time with Alerts');

subplot(3,2,1); h1 = plot(nan, nan, 'b', 'LineWidth', 1.5); hold on;
thr1 = plot(nan, nan, 'ro'); ylabel('Voltage (V)'); title('Voltage'); grid on;

subplot(3,2,2); h2 = plot(nan, nan, 'g', 'LineWidth', 1.5); hold on;
thr2 = plot(nan, nan, 'ro'); ylabel('Current (A)'); title('Current'); grid on;

subplot(3,2,3); h3 = plot(nan, nan, 'm', 'LineWidth', 1.5); hold on;
thr3 = plot(nan, nan, 'ro'); ylabel('DOD'); title('DOD'); grid on;

subplot(3,2,4); h4 = plot(nan, nan, 'k', 'LineWidth', 1.5); hold on;
thr4 = plot(nan, nan, 'ro'); ylabel('Power (W)'); title('Power'); grid on;

subplot(3,2,[5 6]); h5 = plot(nan, nan, 'c', 'LineWidth', 1.5); hold on;
thr5 = plot(nan, nan, 'ro'); xlabel('Time (s)'); ylabel('Energy (Wh)'); title('Wh'); grid on;

% === STEP 3: Read and Plot Live Data ===
while true
    line = readline(s);
    line = strtrim(line);

    if strcmp(line, "START")
        started = true;
        disp("Receiving data...");
        continue;
    elseif strcmp(line, "END")
        disp("Reception complete.");
        break;
    end

    if started
        raw = str2double(strsplit(line, ','));

        if length(raw) < 7
            disp("Skipped: " + line);
            continue;
        end

        values = raw(2:7);  % Skip index (1st column)

        voltage(end+1) = values(1);
        current(end+1) = values(2);
        dod(end+1)     = values(3);
        wh(end+1)      = values(4);
        power(end+1)   = values(5);
        timeVec(end+1) = seconds(datetime('now') - startTime);

        % === POPUP ALERTS ===
        if ~voltageAlertShown && values(1) < 4.1
            msgbox('⚠️ Voltage dropped below 4.1 V', 'Voltage Alert', 'warn');
            voltageAlertShown = true;
        end

        if ~currentAlertShown && values(2) < -0.145
            msgbox('⚠️ Current dropped below -0.145 A', 'Current Alert', 'warn');
            currentAlertShown = true;
        end

        if ~dodAlertShown && values(3) < -0.04
            msgbox('⚠️ DOD dropped below -0.04', 'DOD Alert', 'warn');
            dodAlertShown = true;
        end

        if ~whAlertShown && values(4) < -0.45
            msgbox('⚠️ Energy dropped below -0.45 Wh', 'Energy Alert', 'warn');
            whAlertShown = true;
        end

        if ~powerAlertShown && values(5) < -0.5
            msgbox('⚠️ Power dropped below -0.5 W', 'Power Alert', 'warn');
            powerAlertShown = true;
        end

        % === Threshold marker points ===
        v_thr = voltage < 4.1;
        c_thr = current < -0.145;
        d_thr = dod < -0.04;
        p_thr = power < -0.5;
        w_thr = wh < -0.45;

        % === Update plots ===
        set(h1, 'XData', timeVec, 'YData', voltage);
        set(thr1, 'XData', timeVec(v_thr), 'YData', voltage(v_thr));

        set(h2, 'XData', timeVec, 'YData', current);
        set(thr2, 'XData', timeVec(c_thr), 'YData', current(c_thr));

        set(h3, 'XData', timeVec, 'YData', dod);
        set(thr3, 'XData', timeVec(d_thr), 'YData', dod(d_thr));

        set(h4, 'XData', timeVec, 'YData', power);
        set(thr4, 'XData', timeVec(p_thr), 'YData', power(p_thr));

        set(h5, 'XData', timeVec, 'YData', wh);
        set(thr5, 'XData', timeVec(w_thr), 'YData', wh(w_thr));

        drawnow limitrate;
    end
end

clear s;  % Close serial port
