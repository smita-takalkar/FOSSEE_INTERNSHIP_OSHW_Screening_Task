// My Arduino sketch
int readSensor(int pin) {
  return analogRead(pin);
}

void setupLED() {
  pinMode(13, OUTPUT);
}

void setup() {
  Serial.begin(115200);
  setupLED();
  Serial.println("Started!");
}

void loop() {
  int value = readSensor(A0);
  Serial.print("Sensor: ");
  Serial.println(value);
  delay(1000);
}
