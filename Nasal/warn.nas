var UPDATE_PERIOD = 0.5;

var shturman_light_handler = func {

settimer( shturman_light_handler, UPDATE_PERIOD );
if( getprop("tu134/systems/electrical/buses/Error_bus/volts") == nil ) return;
if( getprop("tu134/systems/electrical/buses/Error_bus/volts") > 15.0 and getprop( "tu134/switches/shturman-light" ) == 1.0)
{ 
        setprop("tu134/light/panel/shturman_ext-blue",
		getprop("tu134/light/panel/shturman_ext-blue-def") );
	setprop("tu134/light/panel/shturman_ext-green",
		getprop("tu134/light/panel/shturman_ext-green-def") );
	setprop("tu134/light/panel/shturman_ext-red",
		getprop("tu134/light/panel/shturman_ext-red-def") );
} else {
        setprop("tu134/light/panel/shturman_ext-blue",0.0);
        setprop("tu134/light/panel/shturman_ext-green",0.0);
        setprop("tu134/light/panel/shturman_ext-red",0.0);
  }
    
}

shturman_light_handler();

print (" Warning and light system load");