#include <PID_v1.h>

int led = 4;
int coil = 8;
int thermwrite = 6;
int thermread = A0;
double Rknown = 11000;
double Vin = 3.3;
double Vmax = 3.3;
bool rising = 1;
unsigned long t0;
unsigned long changetime = 30000;

// Careful if powering from external PSU and connecting with serial - same voltage rail is shared (held at 3.3V).

int thermValue;

double Tdes = 50, T, Output;
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
  t0 = millis();
}

void loop() {
  thermValue = analogRead(thermread);
  T = getTemp(thermValue); // in Celsius
  Serial.println(int(T));

  // LED lights up if within -10/+20 degrees of target
  // Stops script if temperature exceeds this
  if (T > Tdes + 25) {
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

  if (millis() - t0 > changetime) {
    t0 = millis();
    if (rising) {
      Tdes += 5;
      if (Tdes >= 100) {
        rising = 0;
      }
    }
    else {
      Tdes -= 5;
      if (Tdes <= 15) {
        rising = 1;
      }
    }
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
