#include <PID_v1.h>

int led = 4;
int coil = 8;
int thermwrite = 6;
int thermread = A0;
double Rknown = 11000;
double Vin = 3.3;
double Vmax = 3.3;

int thermValue;

double Tdes = 70, T, Output;
double Kp=50, Ki=20, Kd=0;
PID myPID(&T, &Output, &Tdes, Kp, Ki, Kd, DIRECT);

void setup() {
  pinMode(led, OUTPUT);
  pinMode(coil, OUTPUT);
  pinMode(thermwrite, OUTPUT);
  digitalWrite(coil, 1);
  digitalWrite(thermwrite, 1);
  digitalWrite(led, 0);
  Serial.begin(9600);
  myPID.SetMode(AUTOMATIC);
}

void loop() {
//  digitalWrite(led, 1);
//  digitalWrite(coil, 0);
//  thermValue = analogRead(thermread);
//  T = getTemp(thermValue);
//  Serial.println(int(T));
//  delay(3000);
//
//  digitalWrite(led, 0);
//  digitalWrite(coil, 1);
//  thermValue = analogRead(thermread);
//  T = getTemp(thermValue);
//  Serial.println(int(T));
//  delay(3000);

  thermValue = analogRead(thermread);
  T = getTemp(thermValue); // in Celsius
  Serial.println(int(T));
  
  if (T > Tdes + 20) {
    digitalWrite(led, 0);
    Serial.println("Too hot - exiting.");
    exit(0);
  }
  else if (T > Tdes - 10) {
    digitalWrite(led, 1);
  }
  else {
    digitalWrite(led, 0);
  }
  
  myPID.Compute();
  analogWrite(coil, 255 - Output); //PWM: By default, Output is varied between 0 & 255
  
  delay(1000);
}

double getTemp(int thermValue){
  double R = Rknown*(((1023*Vin)/(Vmax*double(thermValue))) - 1);
  double T = 25 + log(R/10000)/log(0.96);
  return T;
}
