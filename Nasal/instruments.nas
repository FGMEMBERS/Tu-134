
var engine_temp_handler = func {
  settimer( engine_temp_handler, 0 );

  altimeter1_handler = func {
  settimer( altimeter1_handler, 0 );
  if( getprop("tu134/systems/svs/powered") != 1 ) return;

  var alt = getprop("instrumentation/altimeter/indicated-altitude-ft");
  if( alt == nil ) { return; }

  alt = alt * 0.3048;	# go to meters

  setprop("tu134/instrumentation/altimeter/indicated-wheels_dec_m", 
  (alt/10.0) - int( alt/100.0 )*10.0 );

  setprop("tu134/instrumentation/altimeter/indicated-wheels_hund_m", 
  (alt/100.0) - int( alt/1000.0 )*10.0 );

  setprop("tu134/instrumentation/altimeter/indicated-wheels_ths_m", 
  (alt/1000.0) - int( alt/10000.0 )*10.0 );

  setprop("tu134/instrumentation/altimeter/indicated-wheels_decths_m", 
  (alt/10000.0) - int( alt/100000.0 )*10.0 );
}

#pressure setting
var altimeter1_pressure_handler = func {
  var pressure = getprop("instrumentation/altimeter/setting-inhg");
  if( pressure == nil ) { return; }
  pressure = pressure * 25.4;	# go to metrics (mmhg)

  setprop("tu134/instrumentation/altimeter/mmhg", pressure );

  setprop("tu134/instrumentation/altimeter/mmhg-wheels_dec", 
  (pressure/10.0) - int( pressure/100.0 )*10.0 );

  setprop("tu134/instrumentation/altimeter/mmhg-wheels_hund", 
  (pressure/100.0) - int( pressure/1000.0 )*10.0 );
}

setlistener("instrumentation/altimeter/setting-inhg", altimeter1_pressure_handler, 0, 0);

altimeter1_handler();

altimeter1_pressure_handler();

if( getprop("engines/engine[0]/egt_degf") == nil ) { return; }
if( getprop("engines/engine[1]/egt_degf") == nil ) { return; }

setprop("engines/engine[0]/egt_degc", getprop("engines/engine[0]/egt_degf")*0.55 -17);
setprop("engines/engine[1]/egt_degc", getprop("engines/engine[1]/egt_degf")*0.55-17);

}

engine_temp_handler();

var tablo_dv_1_up = func {
  light = getprop("tu134/light/tablo_dv_1/power" );
  if ( light < 1.0 ){
    light = light + 0.05;
    setprop("tu134/light/tablo_dv_1/power", light);
  }
}

var tablo_dv_1_down = func {
  light = getprop("tu134/light/tablo_dv_1/power" );
  if ( light > 0.1 ){
    light = light - 0.05;
    setprop("tu134/light/tablo_dv_1/power", light);
  }
}

var shturman_light = func {
  if ( getprop("tu134/switches/shurman-light") == 1.0 ){
    electrical.Error_bus.add_output("Shturman_light", 10.0);
  } else {
    electrical.Error_bus.rm_output( "Shturman_light");
  }
}

setlistener( "tu134/switches/shturman-light", shturman_light,0,0);

var gyro_on = func{

  if( getprop("instrumentation/heading-indicator[0]/serviceable") == nil ) { return; }
  if (getprop("tu134/systems/electrical/buses/AC3x36_bus/volts") == nil ) {return; }

  if (getprop("tu134/systems/electrical/buses/AC3x36_bus/volts") > 30){
    if (getprop("tu134/switches/gyro_on") == 1){
      setprop("instrumentation/heading-indicator[0]/serviceable", 1 );
      electrical.AC3x36_bus.add_output("Gyro_on");
    } else {
      setprop("instrumentation/heading-indicator[0]/serviceable", 0 );
      electrical.AC3x36_bus.rm_output("Gyro_on");
    }
  }
}

gyro_on();

