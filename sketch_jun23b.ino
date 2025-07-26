#include <SD.h>

const int chipSelect = 10;
File myFile;

void setup() {
  Serial.begin(9600);
  while (!Serial) {}

  if (!SD.begin(chipSelect)) {
    Serial.println("SD initialization failed!");
    while (1);
  }

  myFile = SD.open("TESTD.CSV");  // ✅ Match filename on SD card
  if (!myFile) {
    Serial.println("File open failed!");
    while (1);
  }

  Serial.println("START");  // Start marker for MATLAB

  // Skip header
  myFile.readStringUntil('\n');

  int lineCount = 0;
  while (myFile.available() && lineCount < 100) {
    String line = myFile.readStringUntil('\n');
    line.trim();

    if (line.length() > 0) {
      // ✅ Extract only first 7 fields
      int commaCount = 0;
      String cleaned = "";
      for (int i = 0; i < line.length(); i++) {
        char c = line.charAt(i);
        if (c == ',') commaCount++;
        if (commaCount >= 7 && c == ',') break;
        cleaned += c;
      }

      Serial.println(cleaned);
      lineCount++;
      delay(500);  // smooth transmission
    }
  }

  myFile.close();
  Serial.println("END");  // End marker
}

void loop() {
  // Do nothing
}
