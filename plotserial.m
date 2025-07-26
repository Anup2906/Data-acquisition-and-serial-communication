clc;
clear;

% === STEP 1: Set serial port and baud rate ===
port = "COM7";       % ✅ Replace with your Arduino COM port
baudRate = 9600;

% === STEP 2: Create serialport object ===
s = serialport(port, baudRate);
configureTerminator(s, "LF");  % Arduino uses Serial.println() (LF line ending)
flush(s);                      % Clear any previous data

disp("Waiting for bitstream from Arduino...");

bits = [];
started = false;

% === STEP 3: Set up real-time plot ===
figure;
h = stairs(nan, nan, 'LineWidth', 2);
ylim([-0.5, 1.5]);
xlabel('Bit Index');
ylabel('Bit Value');
title('Real-Time Bitstream from Arduino (SD card)');
grid on;

% === STEP 4: Read and plot in real-time ===
while true
    line = readline(s);
    line = strtrim(line);

    if strcmp(line, "START")
        started = true;
        disp("Receiving bits...");
        continue;
    elseif strcmp(line, "END")
        disp("Finished receiving.");
        break;
    end

    if started && (strcmp(line, '0') || strcmp(line, '1'))
        bits(end+1) = str2double(line); %#ok<SAGROW>
        h.XData = 1:length(bits);
        h.YData = bits;
        drawnow limitrate;
    end
end

% === STEP 5: Close serial port ===
clear s;
