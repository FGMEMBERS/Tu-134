#Tu-134A-3 electrical system.

print(getprop("/sim/gui/dialogs"));

var UPDATE_PERIOD = 0.3;

var enode="tu134/systems/electrical/";
var swnode = "tu134/switches/";

var battery1 = nil;
var battery2 = nil;

var GS18_1_1 = nil;
var GS18_1_2 = nil;
var GS18_2_1 = nil;
var GS18_2_2 = nil;
var GS12_APU = nil;

var RAP = nil;

var VU6B_1 = nil;
var VU6B_2 = nil;
var VU6B_3 = nil;

var PT_1000_1 = nil;
var PT_1000_2 = nil;
var PO_4500_1 = nil;
var PO_4500_2 = nil;

var AKK_bus = nil;

var DC27_bus = nil;

var Error_bus = nil;

PT_1000_1_bus = nil;

var AC3x36_bus = nil;

var AC1x115_bus = nil;

var last_time = 0.0;
var bat_src_volts = 0.0;
var alt_flag = 0x00;

var ammeter_ave = 0.0;

update_buses_thandler = func{

    AC3x36_bus.update_voltage();
    AC1x115_bus.update_voltage();

    AKK_bus.update_voltage();
    DC27_bus.update_voltage();
    Error_bus.update_voltage();
    
    PO_4500_1.update();
    PO_4500_2.update();
    
    PT_1000_1_bus.update_voltage();
    PT_1000_1_bus.update_load();
    
    PT_1000_1.update();
    PT_1000_2.update();
    
    AC3x36_bus.update_load();
    AC1x115_bus.update_load();
    
    AKK_bus.update_load();
    DC27_bus.update_load();
    Error_bus.update_load();
    
    settimer(update_buses_thandler, UPDATE_PERIOD );

}


REGULATOR_KP_1_handler = func {
    var n2=getprop("engines/engine[0]/n2");
    setprop("engines/engine[0]/rpm", n2>53 ? n2*73.9 : 0.0);
}
REGULATOR_KP_2_handler = func {
    var n2=getprop("engines/engine[0]/n2");
    setprop("engines/engine[0]/rpm", n2>53 ? n2*73.9 : 0.0);
}
REGULATOR_KP_3_handler = func {
    var n2=getprop("engines/engine[1]/n2");
    setprop("engines/engine[1]/rpm", n2>53 ? n2*73.9 : 0.0);
}
REGULATOR_KP_4_handler = func {
    var n2=getprop("engines/engine[1]/n2");
    setprop("engines/engine[1]/rpm", n2>53 ? n2*73.9 : 0.0);
}

REGULATOR_KP_APU_handler = func {
    var n2=getprop("engines/engine[2]/n2");
    setprop("engines/engine[2]/rpm", n2>53 ? n2*73.9 : 0.0);
}

GS18_1_1_rpm_handler = func {
    GS18_1_1.rpm_handler();
}
GS18_1_2_rpm_handler = func {
    GS18_1_2.rpm_handler();
}
GS18_2_1_rpm_handler = func {
    GS18_2_1.rpm_handler();
}
GS18_2_2_rpm_handler = func {
    GS18_2_2.rpm_handler();
}
GS12_APU_rpm_handler = func {
    GS12_APU.rpm_handler();
}


generator_1_shandler = func{
    if( getprop("tu134/switches/gen_1_1")==1){
	DC27_bus.add_input( GS18_1_1 );
	GS18_1_1.connect_to_bus( DC27_bus );
    } 
    if( getprop("tu134/switches/gen_1_1")==0){
	DC27_bus.rm_input( "GS18_1_1" );
	GS18_1_1.disconnect_from_bus();
	setprop("tu134/lamps/gen_1_1",1.0);
	print("GS18_1_1 Off");
    }
}

generator_2_shandler = func{
    if( getprop("tu134/switches/gen_1_2")==1 ){
	DC27_bus.add_input( GS18_1_2 );
	GS18_1_2.connect_to_bus( DC27_bus );
	DC27_bus.rm_input( "GS12_APU" );
	DC27_bus.rm_input( "RAP" );
	setprop("tu134/lamps/gen_1_2",0.0);
	print(" GS18_1_2 On");
} 
    if( getprop("tu134/switches/gen_1_2")==0 ){
	DC27_bus.rm_input( "GS18_1_2" );
	GS18_1_2.disconnect_from_bus();
	setprop("tu134/lamps/gen_1_2",1.0);
	print("GS18_1_2 Off");
    }
}

generator_3_shandler = func{
    if( getprop("tu134/switches/gen_2_1")==1 ){
	DC27_bus.add_input( GS18_2_1 );
	GS18_2_1.connect_to_bus( DC27_bus );
	if (getprop("tu134/systems/electrical/suppliers/GS18_2_1/volts") > 15.0){
            DC27_bus.rm_input( "AKK_bus" );
            setprop("tu134/lamps/gen_2_1",0.0);
	    print(" GS18_2_1 On");
        }
} 
    if( getprop("tu134/switches/gen_2_1")==0 ){
	DC27_bus.rm_input( "GS18_2_1" );
	GS18_1_1.disconnect_from_bus();
	setprop("tu134/lamps/gen_2_1",1.0);
	print("GS18_2_1 Off");
    }
}

generator_4_shandler = func{
    if( getprop("tu134/switches/gen_2_2")==1 ){
	DC27_bus.add_input( GS18_2_2 );
	GS18_2_2.connect_to_bus( DC27_bus );
	DC27_bus.rm_input( "GS12_APU" );
	DC27_bus.rm_input( "RAP" );
	setprop("tu134/lamps/gen_2_2",0.0);
	print(" GS18_2_2 On");
} 
    if( getprop("tu134/switches/gen_2_2")==0 ){
	DC27_bus.rm_input( "GS18_2_2" );
	GS18_1_1.disconnect_from_bus();
	setprop("tu134/lamps/gen_2_2",1.0);
	print("GS18_2_2 Off");
    }
}

generator_APU_shandler = func{
    if( getprop("tu134/switches/generator-APU")==1 ){
	DC27_bus.add_input( GS12_APU );
	GS12_APU.connect_to_bus( DC27_bus );
	DC27_bus.rm_input( "AKK_bus" );
	DC27_bus.rm_input( "RAP" );
	setprop("tu134/lamps/generator-APU",0.0);
	print(" Generator APU on");
    } 
    if( getprop("tu134/switches/generator-APU")==0 ){
	DC27_bus.rm_input( "GS12_APU" );
	GS12_APU.disconnect_from_bus();
	setprop("tu134/lamps/generator-APU`",1.0);
	print("Generator APU Off");
    }
}

battery_1_handler = func{
    if( getprop("tu134/switches/akk_1")==1 ){
	AKK_bus.add_input( battery1 );
	battery1.connect_to_bus( AKK_bus );
#	setprop("tu134/lamps/akk_lamp",1.0);
	print("Batery 1 On");
    } 
    if( getprop("tu134/switches/akk_1")==0 ){
	AKK_bus.rm_input( battery1.name );
	battery1.disconnect_from_bus();
#       setprop("tu134/lamps/battery",0.0);
	print("Battery 1 Off");
    }
}

battery_2_handler = func{
    if( getprop("tu134/switches/akk_2")==1 ){
	AKK_bus.add_input( battery2 );
	battery2.connect_to_bus( AKK_bus );
#	setprop("tu134/lamps/battery",1.0);
	print("Batery 2 On");
} 
    if( getprop("tu134/switches/akk_2")==0 ){
	AKK_bus.rm_input( battery2.name );
	battery2.disconnect_from_bus();
#       setprop("tu134/lamps/battery",0.0);
	print("Battery 2 Off");
}
}

VU6B_1_shandler = func{
    if( getprop("tu134/switches/vypr-1")==1 ){
	AC3x200_bus_1L.add_output( "VU6B-1", 0.0);
	DC27_bus_L.add_input( VU6B_1 );
	print(" VU6B-1 On");
    } 
    if( getprop("tu134/switches/vypr-1")==0 ){
	DC27_bus_L.rm_input( "VU6B-1" );
	AC3x200_bus_1L.rm_output( "VU6B-1" );
	print(" VU6B-1 Off");
    }
}

VU6B_2_shandler = func{
    if( getprop("tu134/switches/vypr-2")==1 ){
	AC3x200_bus_3R.add_output( "VU6B-2", 0.0);
	DC27_bus_R.add_input( VU6B_2 );
	print(" VU6B-2 On");
    } 
    if( getprop("tu134/switches/vypr-2")==0 ){
	DC27_bus_R.rm_input( "VU6B-2" );
	AC3x200_bus_3R.rm_output( "VU6B-2" );
	print(" VU6B-2 Off");
    }
}

APU_RAP_shandler = func{
    if( getprop("tu134/switches/APU-RAP-selector")==0 ){
	AKK_bus.add_input( GS12_APU );
	AKK_bus.rm_input( "RAP");
	print(" APU On");
    } 
    if( getprop("tu134/switches/APU-RAP-selector")==1 ){
	AKK_bus.rm_input( "GS12_APU" );
	AKK_bus.rm_input( "RAP");
	print(" APU-RAP Off");
    }
    if( getprop("tu134/switches/APU-RAP-selector")==2 ){
	AKK_bus.add_input( RAP );
	
	AKK_bus.rm_input( "GS12_APU" );
	print(" RAP On");
    }
}

DC27_onbus_handler = func{
    if( getprop("tu134/switches/on_bus")==1 ){
        DC27_bus.add_input( AKK_bus );
        setprop ("tu134/lamps/akk_lamp", 1.0);
        print(" DC27 On bus");
    } 
    if ( getprop("tu134/switches/on_bus")==0 ){
        DC27_bus.rm_input( "AKK_bus" );
        setprop ("tu134/lamps/akk_lamp", 0.0);
        print(" DC27 Off bus");
    }
}


init_electrical = func {
    print("Initializing Nasal Electrical System");

    battery1 = BatteryClass.new( "A20NKBN25-1" );
    battery2 = BatteryClass.new( "A20NKBN25-2" );
    
    GS18_1_1 = DCAlternatorClass.new( "GS18_1_1" );
    GS18_1_1.rpm_source( props.globals.getNode("engines/engine[0]") );
    GS18_1_2 = DCAlternatorClass.new( "GS18_1_2" );
    GS18_1_2.rpm_source( props.globals.getNode("engines/engine[0]") );
    GS18_2_1 = DCAlternatorClass.new( "GS18_2_1" );
    GS18_2_1.rpm_source( props.globals.getNode("engines/engine[1]") );
    GS18_2_2 = DCAlternatorClass.new( "GS18_2_2" );
    GS18_2_2.rpm_source( props.globals.getNode("engines/engine[1]") );
    GS12_APU = DCAlternatorClass.new( "GS12_APU" );
    GS12_APU.rpm_source( props.globals.getNode("engines/engine[2]") );

    RAP = ExternalClass.new("RAP");

    PO_4500_1 = DCACinverterClass.new("PO-4500-1", 0.23 );
    PO_4500_2 = DCACinverterClass.new("PO-4500-2", 0.23 );
    
    PT_1000_1 = DCACinverterClass.new("PT-1000-1", 1.33 );
    PT_1000_2 = DCACinverterClass.new("PT-1000-2", 1.33 );
        
    AKK_bus = DCBusClass.new( "AKK_bus");
    Error_bus = DCBusClass.new( "Error_bus" );
    DC27_bus = DCBusClass.new( "DC27_bus" );
        
    PT_1000_1_bus = DCBusClass.new ( "PT_1000_1_bus" );

    AC3x36_bus = ACBusClass.new( "AC3x36-bus" );
   
    AC1x115_bus = ACBusClass.new( "AC1x115-bus" );
        
#--------- connect buses ------------------
    
#    DC27_bus_Lv.add_output( "DC27-bus-L" ,0.0);
#    DC27_bus_Rv.add_output( "DC27-bus-R" ,0.0);

#    DC27_bus_Lv.add_output( "POS-125" ,20.0);
#    DC27_bus_Lv.add_output( "PTS-250-1" ,20.0);
#    DC27_bus_Rv.add_output( "PTS-250-2" ,20.0);

#    AC3x36_bus.add_input( PT_1000_1 );
#    AC3x36_bus.add_input( PT_1000_2 );
    
    PT_1000_1.add_input ( PT_1000_1_bus );
    AC3x36_bus.add_input( PT_1000_1 );
                                 
    AC1x115_bus.add_input( PO_4500_1 );
    AC1x115_bus.add_input( PO_4500_2 );
#    AC3x200_bus_1L.add_output( "VU6B-1", 25.0);
#    AC3x200_bus_3R.add_output( "VU6B-2", 25.0);
#    AC3x200_bus_1L.add_output( "TSZZOSS4B-1",10.0);
#    AC3x200_bus_3R.add_output( "TSZZOSS4B-2",10.0);

#    TSZZOSS4B_1.add_input( AC3x200_bus_1L );
#    TSZZOSS4B_2.add_input( AC3x200_bus_3R );

#PTS_250_1.add_input( DC27_bus_Lv );
#    PTS_250_2.add_input( DC27_bus_Rv );
#    POS_125.add_input( DC27_bus_Lv );

#    VU6B_1.add_input( AC3x200_bus_1L );
#    VU6B_2.add_input( AC3x200_bus_3R );



    setprop("tu134/switches/akk_1", 0);
    setlistener("tu134/switches/akk_1", battery_1_handler,0,0 );
    setprop("tu134/switches/akk_2", 0);
    setlistener("tu134/switches/akk_2", battery_2_handler,0,0 );
    
    

    setprop("tu134/switches/gen_1_1", 0);  
    setlistener("tu134/switches/gen_1_1", generator_1_shandler,0,0 );
    setprop("tu134/switches/gen_1_2", 0);  
    setlistener("tu134/switches/gen_1_2", generator_2_shandler,0,0 );
    setprop("tu134/switches/gen_2_1", 0);  
    setlistener("tu134/switches/gen_2_1", generator_3_shandler,0,0 );
    setprop("tu134/switches/gen_2_2", 0);  
    setlistener("tu134/switches/gen_2_2", generator_4_shandler,0,0 );
    setprop("tu134/switches/generator-APU", 0);  
    setlistener("tu134/switches/generator-APU", generator_APU_shandler,0,0 );

    setprop("tu134/switches/on_bus", 0);
    setlistener("tu134/switches/on_bus", DC27_onbus_handler,0,0);
    
    setprop("tu134/switches/pt-1000-1",0);
    setprop("tu134/switches/pt-1000-2",0);
    
  setprop("tu134/switches/ut7-3-serviceable", 0);  
  setprop("tu134/switches/pump-1-serviceable", 0);  
  setprop("tu134/switches/pump-2-serviceable", 0);  
  setprop("tu134/switches/pump-3-serviceable", 0);  
  setprop("tu134/switches/pump-4-serviceable", 0);  
  setprop("tu134/switches/tank-4-serviceable", 0);  
  setprop("tu134/switches/tank-3-left-serviceable", 0);  
  setprop("tu134/switches/tank-3-right-serviceable", 0);  
  setprop("tu134/switches/tank-2-left-serviceable", 0);  
  setprop("tu134/switches/tank-2-right-serviceable", 0);  
  setprop("tu134/switches/zk-selector", 0);  
  setprop("tu134/switches/fuel-meter-serviceable", 0);  
  setprop("tu134/switches/fuel-autolevel-serviceable", 0);  
  setprop("tu134/switches/fuel-autoconsumption-mode", 0);  
  setprop("tu134/switches/fuel-consumption-meter", 0);  
  setprop("tu134/switches/ext-hydro-pump-2", 0);  
  setprop("tu134/switches/ext-hydro-pump-3", 0);  
  setprop("tu134/switches/APU-starter-switch", 0);  
  setprop("tu134/switches/APU-starter-selector", 0);  
  setprop("tu134/switches/AUASP", 0);  
  setprop("tu134/switches/AUASP-check", 0);  
  setprop("tu134/switches/main-battery", 0);  
  setprop("tu134/switches/UVID", 0);  
  setprop("tu134/switches/EUP", 0);  
    setprop("tu134/switches/AGR", 0);  
#   setlistener("tu134/switches/AGR", AGR_shandler,0,0 );
  setprop("tu134/switches/TKC-power-1", 0);  
  setprop("tu134/switches/TKC-power-2", 0);  
  setprop("tu134/switches/TKC-heat", 0);  
  setprop("tu134/switches/TKC-BGMK-1", 0);  
  setprop("tu134/switches/TKC-BGMK-2", 0);  
  setprop("tu134/switches/KURS-PNP-left", 0);  
  setprop("tu134/switches/KURS-PNP-right", 0);  
    setprop("tu134/switches/vypr-1", 0);  
    setlistener("tu134/switches/vypr-1", VU6B_1_shandler,0,0 );
  setprop("tu134/switches/SVS-power", 0);  
  setprop("tu134/switches/SVS-heat", 0);  
  setprop("tu134/switches/fasten-seat-belts", 0);  
  setprop("tu134/switches/no-smoking", 0);  
  setprop("tu134/switches/exit", 0);  
  setprop("tu134/switches/pito-heat", 0);  
  setprop("tu134/switches/DISS-power", 0);  
  setprop("tu134/switches/DISS-surface", 0);  
  setprop("tu134/switches/DISS-check", 0);  
  setprop("tu134/switches/KURS-MP-1", 0);  
    setprop("tu134/switches/vypr-2", 0);  
    setlistener("tu134/switches/vypr-2", VU6B_2_shandler,0,0 );
  setprop("tu134/switches/KURS-MP-2", 0);  
  setprop("tu134/switches/RSBN-power", 0);  
  setprop("tu134/switches/RSBN-opozn", 0);  
  setprop("tu134/switches/RV-5-1", 0);  
  setprop("tu134/switches/RV-5-2", 0);  
  setprop("tu134/switches/comm-power-1", 0);  
  setprop("tu134/switches/comm-power-2", 0);  
  setprop("tu134/switches/adf-power-1", 0);  
  setprop("tu134/switches/adf-power-2", 0);  
  setprop("tu134/switches/stab-hyro-1", 0);  
  setprop("tu134/switches/stab-hyro-2", 0);  
  setprop("tu134/switches/landing-light-retract", 0);  
  setprop("tu134/switches/ut7-1-serviceable", 0);  
  setprop("tu134/switches/ut7-2-serviceable", 0);  
#  setprop("tu134/switches/azs1-1", 0);  
#  setprop("tu134/switches/azs1-1", 0);  
  setprop("tu134/switches/BKK-test", 0);  
  setprop("tu134/switches/BKK-test-cover", 0);  
  setprop("tu134/switches/BKK-power", 0);  
  setprop("tu134/switches/BKK-power-cover", 0);  
  setprop("tu134/switches/SAU-STU", 0);  
  setprop("tu134/switches/SAU-STU-cover", 0);  
  setprop("tu134/switches/PKP-left", 0);  
  setprop("tu134/switches/PKP-left-cover", 0);  
  setprop("tu134/switches/PKP-right", 0);  
  setprop("tu134/switches/PKP-right-cover", 0);  
  setprop("tu134/switches/MGV-contr", 0);  
  setprop("tu134/switches/MGV-contr-cover", 0);  
  setprop("tu134/switches/steering", 0);  
  setprop("tu134/switches/steering-cover", 0);  
  setprop("tu134/switches/steering-limit", 0);  
  setprop("tu134/switches/steering-limit-cover", 0);  
  setprop("tu134/switches/transfer-valve-1", 0);  
  setprop("tu134/switches/transfer-valve-1-cover", 0);  
  setprop("tu134/switches/transfer-valve-2", 0);  
  setprop("tu134/switches/transfer-valve-2-cover", 0);  
  setprop("tu134/switches/emergency-alternator", 0);  
  setprop("tu134/switches/emergency-alternator-cover", 0);  
  setprop("tu134/switches/APU-cutoff-valve", 0);  
  setprop("tu134/switches/APU-cutoff-valve-cover", 0);  
  setprop("tu134/switches/hydrosystem-1-to-2", 0);  
  setprop("tu134/switches/hydrosystem-1-to-2-cover", 0);  
  setprop("tu134/switches/fuel-autoconsumption-serviceable", 0);  
  setprop("tu134/switches/fuel-autoconsumption-serviceable-cover", 0);  
  setprop("tu134/switches/fuel-cutoff-valve-1", 0);  
  setprop("tu134/switches/fuel-cutoff-valve-1-cover", 0);  
  setprop("tu134/switches/fuel-cutoff-valve-2", 0);  
  setprop("tu134/switches/fuel-cutoff-valve-2-cover", 0);  
  setprop("tu134/switches/fuel-cutoff-valve-3", 0);  
  setprop("tu134/switches/fuel-cutoff-valve-3-cover", 0);  
#  setprop("tu134/switches/azs3-1", 0);  
  setprop("tu134/switches/capt-idr-selector", 0);  
  setprop("tu134/switches/copilot-idr-selector", 0);  
  setprop("tu134/switches/APU-bleed", 1);  
    setprop("tu134/switches/APU-RAP-selector", 1);  
    setlistener("tu134/switches/APU-RAP-selector", APU_RAP_shandler,0,0 );
  setprop("tu134/switches/headlight-mode", 1);  
  setprop("tu134/switches/voltage-src-selector", 0);  
  setprop("tu134/switches/voltage-phase-selector", 0);  
  setprop("tu134/switches/current-src-selector", 0);  
  setprop("tu134/switches/current-phase-selector", 0);  
  setprop("tu134/switches/dc-src-selector", 0);  
  setprop("tu134/switches/POS", 0);  


    setlistener("engines/engine[0]/n2", REGULATOR_KP_1_handler,0,0 );
    setlistener("engines/engine[0]/n2", REGULATOR_KP_2_handler,0,0 );
    setlistener("engines/engine[1]/n2", REGULATOR_KP_3_handler,0,0 );
    setlistener("engines/engine[1]/n2", REGULATOR_KP_4_handler,0,0 );
    setlistener("engines/engine[2]/n2", REGULATOR_KP_4_handler,0,0 );

    setlistener("engines/engine[0]/rpm", GS18_1_1_rpm_handler,0,0 );
    setlistener("engines/engine[0]/rpm", GS18_1_2_rpm_handler,0,0 );
    setlistener("engines/engine[1]/rpm", GS18_2_1_rpm_handler,0,0 );
    setlistener("engines/engine[1]/rpm", GS18_2_2_rpm_handler,0,0 );
    setlistener("engines/engine[2]/rpm", GS12_APU_rpm_handler,0,0 );

    settimer(update_buses_thandler, UPDATE_PERIOD );
settimer(update_electrical, 0);
}


setlistener("/sim/signals/fdm-initialized", init_electrical);

var PT_1000_1_on_bus_handler = func {
  
  if (getprop("tu134/switches/pt-1000-1") == 1) {
      PT_1000_1_bus.add_input( DC27_bus );
      print ("PT-1000 on bus");
} else {
      PT_1000_1_bus.rm_input( "DC27_bus" );
      print ("PT-1000 out bus");
}
}

var PT_1000_2_on_bus_handler = func {

    if (getprop("tu134/switches/pt-1000-2") == 1) {
      AC3x36_bus.add_input( DC27_bus );
} else {
      AC3x36_bus.rm_input( "DC27_bus" );
}
}

setlistener("tu134/switches/pt-1000-1", PT_1000_1_on_bus_handler);
setlistener("tu134/switches/pt-1000-2", PT_1000_2_on_bus_handler);


update_electrical = func {
    settimer(update_electrical, UPDATE_PERIOD);
#instruments.update_electrical();
# Added by Yurik 
# Electrical panel gauges and lamps support

# AC 
var src = getprop( "tu134/switches/voltage-src-selector" );
if( src == nil ) src = 0;
var voltage = 0.0;
var freq = 0.0;
if( src == 0 ) {
	voltage = getprop( "tu134/systems/electrical/suppliers/GT40-1/volts" );
	freq = getprop( "tu134/systems/electrical/suppliers/GT40-1/frequency" );
	}
if( src == 1 ) {
	voltage = getprop( "tu134/systems/electrical/suppliers/GT40-2/volts" );
	freq = getprop( "tu134/systems/electrical/suppliers/GT40-2/frequency" );
	}
if( src == 2 ) {
	voltage = getprop( "tu134/systems/electrical/suppliers/GT40-3/volts" );
	freq = getprop( "tu134/systems/electrical/suppliers/GT40-3/frequency" );
	}
if( src == 3 ) {
	voltage = getprop( "tu134/systems/electrical/suppliers/GT40-APU/volts" );
	freq = getprop( "tu134/systems/electrical/suppliers/GT40-APU/frequency" );
	}
if( src == 4 ) {
	voltage = getprop( "tu134/systems/electrical/buses/AC3x200-bus-1L/volts" );
	freq = getprop( "tu134/systems/electrical/suppliers/AC3x200-bus-1L/frequency" );
	}
if( src == 5 ) {
	voltage = getprop( "tu134/systems/electrical/buses/AC3x200-bus-2/volts" );
	freq = getprop( "tu134/systems/electrical/suppliers/AC3x200-bus-2/frequency" );
	}
if( src == 6 ) {
	voltage = getprop( "tu134/systems/electrical/buses/AC3x200-bus-3L/volts" );
	freq = getprop( "tu134/systems/electrical/suppliers/AC3x200-bus-3L/frequency" );
	}
	
	if( voltage == nil ) voltage = 0.0;
	if( freq == nil ) freq = 0.0;
# v=v/sqrt(3);
	interpolate("tu134/instrumentation/electrical/v200", voltage/1.73, UPDATE_PERIOD );
	interpolate("tu134/instrumentation/electrical/hz200", freq, UPDATE_PERIOD );
	
src = getprop( "tu134/switches/current-src-selector" );
if( src == nil ) src = 0;
var current = 0.0;
if( src == 0 ) 
	current = getprop( "tu134/systems/electrical/buses/AC3x200-bus-1L/load" );
if( src == 1 ) 
	current = getprop( "tu134/systems/electrical/buses/AC3x200-bus-2/load" );
if( src == 2 ) 
	current = getprop( "tu134/systems/electrical/buses/AC3x200-bus-3L/load" );
if( src == 4 ) # It's evil hack... 
	current = getprop( "tu134/systems/electrical/buses/AC3x200-bus-1L/load" );
	
	if( current == nil ) current = 0.0;
	
	interpolate("tu134/instrumentation/electrical/a200", current, UPDATE_PERIOD );
# DC
src = getprop( "tu134/switches/dc-src-selector" );
if( src == nil ) src = 0;
if( src == 0 )
	voltage = getprop( "tu134/systems/electrical/buses/DC27-bus-L/volts" );
if( src == 1 )
	voltage = getprop( "tu134/systems/electrical/suppliers/A20NKBN25U3-1/volts" );
	if( voltage == nil ) voltage = 0.0;
	interpolate("tu134/instrumentation/electrical/v27", voltage, UPDATE_PERIOD );
# Only for demo!
	current = getprop( "tu134/systems/electrical/buses/DC27-bus-Lv/load" );
	if( current == nil ) current = 0.0;
	interpolate("tu134/instrumentation/electrical/a27", current, UPDATE_PERIOD );

# Лампочки генераторов
if (getprop("tu134/switches/gen_1_1") == 1.0 and getprop("tu134/systems/electrical/suppliers/GS18_1_1/volts") > 15.0){
    setprop("tu134/lamps/gen_1_1", 0.0);
    } else {
    setprop("tu134/lamps/gen_1_1", 1.0);
}
if (getprop("tu134/switches/gen_1_2") == 1.0 and getprop("tu134/systems/electrical/suppliers/GS18_1_2/volts") > 15.0){
    setprop("tu134/lamps/gen_1_2", 0.0);
} else {
    setprop("tu134/lamps/gen_1_2", 1.0);
}
if (getprop("tu134/switches/gen_2_1") == 1.0 and getprop("tu134/systems/electrical/suppliers/GS18_2_1/volts") > 15.0){
    setprop("tu134/lamps/gen_2_1", 0.0);
} else {
    setprop("tu134/lamps/gen_2_1", 1.0);
}
if (getprop("tu134/switches/gen_2_2") == 1.0 and getprop("tu134/systems/electrical/suppliers/GS18_2_2/volts") > 15.0){
    setprop("tu134/lamps/gen_2_2", 0.0);
} else {
    setprop("tu134/lamps/gen_2_2", 1.0);
}

# Лампочка работы от аккумулятора
akk_voltage = getprop( "tu134/systems/electrical/buses/AKK_bus/volts" );
if( akk_voltage == nil ) akk_voltage = 0.0;

if (akk_voltage > 16.0){
  if (getprop("tu134/switches/on_bus") > 0.1){
    if (getprop("tu134/systems/electrical/suppliers/GS18_1_1/volts") > 15.0 and getprop("tu134/switches/gen_1_1") == 1.0){
            DC27_bus.rm_input( "AKK_bus" );
            setprop("tu134/lamps/akk_lamp",0.0);
    } elsif (getprop("tu134/systems/electrical/suppliers/GS18_1_2/volts") > 15.0 and getprop("tu134/switches/gen_1_2") == 1.0){
            DC27_bus.rm_input( "AKK_bus" );
            setprop("tu134/lamps/akk_lamp",0.0);
    } else {
    setprop("tu134/lamps/akk_lamp",1.0);
#    print(" GS18_1_1 Off");
    }
  }
}

# getprop("tu134/systems/electrical/suppliers/GS18_1_2/volts") > 15.0 or 
#  getprop("tu134/systems/electrical/suppliers/GS18_2_1/volts") > 15.0 or 
# getprop("tu134/systems/electrical/suppliers/GS18_2_2/volts") > 15.0)   

# Error bus
if ( getprop( "tu134/systems/electrical/buses/DC27_bus/volts" ) > 15.0 ){
    Error_bus.add_input( DC27_bus );
    Error_bus.rm_input( "AKK_bus" );
    } else {
    Error_bus.rm_input( "DC27_bus" );
    Error_bus.add_input( AKK_bus );
}


# Lamps
akk_voltage = getprop( "tu134/systems/electrical/buses/AKK_bus/volts" );
dc27_voltage = getprop( "tu134/systems/electrical/buses/DC27_bus/volts" );
if( akk_voltage == nil ) akk_voltage = 0.0;
if( dc27_voltage == nil ) dc27_voltage = 0.0;
if( akk_voltage > 15.0 ){
	if ( dc27_voltage > 15.0 ){
#	   setprop("tu134/lamps/akk_lamp",0.0);
        } else {
#           setprop("tu134/lamps/akk_lamp",1.0);
        }
      }
else	{
	setprop("tu134/lamps/npk-left", 0.0);
	setprop("tu134/lamps/npk-right", 0.0);
	setprop("tu134/lamps/gen-1-failure", 0.0);
	setprop("tu134/lamps/gen-2-failure", 0.0);
	setprop("tu134/lamps/gen-3-failure", 0.0);
	setprop("tu134/lamps/akk_lamp", 0.0);
	interpolate("tu134/instrumentation/electrical/v27", 0.0, UPDATE_PERIOD );
	interpolate("tu134/instrumentation/electrical/a27", 0.0, UPDATE_PERIOD );
	interpolate("tu134/instrumentation/electrical/a200", 0.0, UPDATE_PERIOD );
	interpolate("tu134/instrumentation/electrical/v200", 0.0, UPDATE_PERIOD );
	interpolate("tu134/instrumentation/electrical/hz200", 0.0, UPDATE_PERIOD );
	}

# Blank landing light if altitude above 100 m
var hd_input = getprop("tu134/light/headlight");
if( hd_input == nil ) hd_input = 0.0;
if(  hd_input > 0.0 )
	{
	var alt_blanker = getprop("position/altitude-agl-ft");
	alt_blanker = ( 300.0 - alt_blanker ) * 0.0033;
	if( alt_blanker < 0.0 ) alt_blanker = 0.0;
	if( alt_blanker > 1.0 ) alt_blanker = 1.0;
	interpolate("tu134/light/alpha", alt_blanker, UPDATE_PERIOD);
	}
	else setprop("tu134/light/alpha", 0.0 );
}

#---- Buses -----

DCBusClass = {};

DCBusClass.new = func( name ) {
    obj = { parents : [DCBusClass],
#	    node :  props.globals.getNode( enode ~ "buses/" ~ name , 1 ),
	    node :  enode ~ "buses/" ~ name ~"/" ,
	    name :  name,
	    volts :  props.globals.getNode( enode ~ "buses/" ~ name ~ "/volts", 1 ),
	    load : props.globals.getNode( enode ~ "buses/" ~ name ~ "/load", 1 ),
	    inputs : props.globals.getNode( enode ~ "buses/" ~ name ~ "/inputs", 1 ),
	    outputs : props.globals.getNode( enode ~ "buses/" ~ name ~ "/ouputs", 1 ) };
    obj.volts.setValue(0.0);
    obj.load.setValue(0.0);
    return obj;
}

DCBusClass.add_input = func( obj ) {
    me.inputs.getNode( obj.name, 1).setValue( obj.node );
}

DCBusClass.add_output = func( name, load ) {
    me.outputs.getNode( name, 1).setValues({ "load" : load});
}

DCBusClass.rm_input = func( name ) {
    me.inputs.removeChild( name,0 );
}

DCBusClass.rm_output = func( name ) {
    me.outputs.removeChild( name,0 );
}

DCBusClass.voltage = func {
    return me.volts.getValue();
}

DCBusClass.update_intput = func( name, volts ) {
    me.inputs.getNode( name ).setValues( { "volts" : volts } );
}

DCBusClass.update_output = func( name, load ) {
    me.ouputs.getNode( name ).setValues( { name : load } );
}

DCBusClass.update_load = func {
    load = 0.0;
    outputs =  me.outputs.getChildren();
    if(outputs == nil) return;
    foreach( output; outputs ){
	load += output.getNode("load").getValue();
    }
    me.load.setValue( load );
}

DCBusClass.update_voltage = func {
    volts = 0.0;
    foreach( input; me.inputs.getChildren() ){
	ivolts = props.globals.getNode( input.getValue() ~ "volts" ).getValue();
	volts = volts < ivolts ? ivolts : volts;
    }
    me.volts.setValue( volts );
}


ACBusClass = {};

ACBusClass.new = func( name ) {
    obj = { parents : [ACBusClass],
#	    node :  props.globals.getNode( enode ~ "buses/" ~ name , 1 ),
	    node :  enode ~ "buses/" ~ name ~ "/",
	    name :  name,
	    volts :  props.globals.getNode( enode ~ "buses/" ~ name ~ "/volts", 1 ),
	    load : props.globals.getNode( enode ~ "buses/" ~ name ~ "/load", 1 ),
	    frequency: props.globals.getNode( enode ~ "buses/" ~ name ~ "/frequency", 1 ),
	    inputs : props.globals.getNode( enode ~ "buses/" ~ name ~ "/inputs", 1 ),
	    outputs : props.globals.getNode( enode ~ "buses/" ~ name ~ "/ouputs", 1 ) };
    obj.volts.setValue(0.0);
    obj.load.setValue(0.0);
    obj.frequency.setValue(0.0);
    return obj;
}

ACBusClass.add_input = func( obj  ) {
    me.inputs.getNode( obj.name, 1).setValue( obj.node );
}

ACBusClass.add_output = func( name, load ) {
    me.outputs.getNode( name, 1).setValues({ "load" : load});
}

ACBusClass.rm_input = func( name ) {
    me.inputs.removeChild( name,0 );
}

ACBusClass.rm_output = func( name ) {
    me.outputs.removeChild( name,0 );
}

ACBusClass.voltage = func {
    return me.volts.getValue();
}

ACBusClass.update_intput = func( name, volts, freq ) {
    me.inputs.getNode( name ).setValues( { "volts" : volts, "frequency": freq } );
}

ACBusClass.update_output = func( name, load ) {
    me.ouputs.getNode( name ).setValues( { "load" : load } );
}

ACBusClass.update_load = func {
    load = 0.0;
    outputs = me.outputs.getChildren();
    if(outputs == nil) return;
    foreach( output;  outputs ){
	load += output.getNode("load").getValue();
    }
    me.load.setValue( load );
}

ACBusClass.update_voltage = func {
    volts = 0.0;
    freq = 0.0;
    foreach( input; me.inputs.getChildren() ){
	ivolts = getprop( input.getValue() ~ "/volts" );
	ifreq  = getprop( input.getValue() ~ "/frequency" );
       	freq   = volts < ivolts ? ifreq : me.frequency.getValue();
	volts  = volts < ivolts ? ivolts : volts;
    }
    me.volts.setValue( volts );
    me.frequency.setValue( freq );
}

#---- Batterys ------

BatteryClass = {};
BatteryClass.new = func ( name ) {
    obj = { parents : [BatteryClass],
	    name : name,
	    node :   enode ~ "suppliers/" ~ name ~ "/",
	    volts :  props.globals.getNode( enode ~ "suppliers/" ~ name ~ "/volts", 1 ),
            bus :  nil,
            ideal_volts : 27.0,
            ideal_amps : 30.0,
            amp_hours : 25.0,
            charge_percent : 1.0,
            charge_amps : 7.0 };
    obj.volts.setValue(27.0);
    return obj;
}
BatteryClass.apply_load = func( amps, dt ) {
    amphrs_used = amps * dt / 3600.0;
    percent_used = amphrs_used / me.amp_hours;
    me.charge_percent -= percent_used;
    if ( me.charge_percent < 0.0 ) {
        me.charge_percent = 0.0;
    } elsif ( me.charge_percent > 1.0 ) {
        me.charge_percent = 1.0;
    }
    return me.amp_hours * me.charge_percent;
}
BatteryClass.get_output_volts = func {
    x = 1.0 - me.charge_percent;
    factor = x / 10;
    return me.ideal_volts - factor;
}
BatteryClass.get_output_amps = func {
    x = 1.0 - me.charge_percent;
    tmp = -(3.0 * x - 1.0);
    factor = (tmp*tmp*tmp*tmp*tmp + 32) / 32;
    return me.ideal_amps * factor;
}

BatteryClass.connect_to_bus = func( _bus ){
    me.bus = _bus;
}

BatteryClass.disconnect_from_bus = func{
    me.bus = nil;
}

#---- Alernators

DCAlternatorClass = {};
DCAlternatorClass.new = func( name ) {
    obj = { parents : [DCAlternatorClass],
	    name : name,
	    node :  enode ~ "suppliers/" ~ name ~ "/",
	    volts :   props.globals.getNode( enode ~ "suppliers/" ~ name ~ "/volts", 1 ),
	    engine : nil,
	    bus : nil,
            ideal_volts : 28.5,
	    ideal_amps : 600.0 };
    props.globals.getNode(obj.node,1).setValues({ "volts": 0.0} );
    return obj;
}


DCAlternatorClass.apply_load = func( amps, dt ) {
    rpm = me.engine.getNode("rpm").getValue();
    available_amps = me.ideal_amps * math.ln(rpm)/9;
    return available_amps - amps;
}

DCAlternatorClass.rpm_handler = func {
    rpm = me.engine.getNode("rpm").getValue();
    if( rpm < 1000.0 ) volts = 0.0;
    else volts = me.ideal_volts*math.ln(rpm)/9;
    me.volts.setValue( volts );
    if( me.bus != nil ) setprop(me.bus.volts, volts );
}

DCAlternatorClass.get_output_amps = func(src ){
    rpm = getprop( src );
    if( rpm == nil ) rpm = 0;
    # APU can have 0 rpm
    if (rpm < 1000.0 ) {
        factor = 0;
    } else {
        factor = math.ln(rpm)/4;
    }
    return me.ideal_amps * factor;
}

DCAlternatorClass.connect_to_bus = func( _bus ){
    me.bus = _bus;
}

DCAlternatorClass.disconnect_from_bus = func{
    me.bus = nil;
}

DCAlternatorClass.rpm_source = func( eng ){
    me.engine = eng;
}

DCAlternatorClass.voltage = func( eng ){
    return me.volts.getValue();
}

TransformerClass = {};

TransformerClass.new = func( name, coeff ) {
    obj = { parents : [TransformerClass],
	    name : name,
	    node :  enode ~ "suppliers/" ~ name ~ "/",
	    volts :   props.globals.getNode( enode ~ "suppliers/" ~ name ~ "/volts", 1 ),
	    frequency :  props.globals.getNode( enode ~ "suppliers/" ~ name ~ "/frequency", 1 ),
	    input : nil,
	    output : nil,
	    trans_coeff : coeff };
    props.globals.getNode(obj.node,1).setValues({ "volts": 0.0, "frequency" : 400.0} );
    return obj;
}

TransformerClass.add_input = func( obj ){
    me.input = obj;
}

TransformerClass.output = func( obj ){
    me.output = obj;
}

TransformerClass.update = func{
    volts = me.input == nil ? 0.0 : me.input.volts.getValue()*me.trans_coeff ;
    me.volts.setValue(volts);
}

ACDCconverterClass = {};

ACDCconverterClass.new = func( name, coeff ) {
    obj = { parents : [ACDCconverterClass],
	    name : name,
	    node :  enode ~ "suppliers/" ~ name ~ "/",
	    volts :   props.globals.getNode( enode ~ "suppliers/" ~ name ~ "/volts", 1 ),
	    frequency :  props.globals.getNode( enode ~ "suppliers/" ~ name ~ "/frequency", 1 ),
	    input : nil,
	    output : nil,
	    conv_coeff : coeff };
    props.globals.getNode(obj.node,1).setValues({ "volts": 0.0, "frequency" : 400.0} );
    return obj;
}

ACDCconverterClass.add_input = func( obj ){
    me.input = obj;
}

ACDCconverterClass.output = func( obj ){
    me.output = obj;
}

ACDCconverterClass.update = func{
    volts = me.input == nil ? 0.0 : me.input.volts.getValue()*me.conv_coeff ;
    me.volts.setValue(volts);
}

DCACinverterClass = {};

DCACinverterClass.new = func( name, coeff ) {
  obj = { parents : [DCACinverterClass],
  name : name,
  node :  enode ~ "suppliers/" ~ name ~ "/",
  volts :   props.globals.getNode( enode ~ "suppliers/" ~ name ~ "/volts", 1 ),
  frequency :  props.globals.getNode( enode ~ "suppliers/" ~ name ~ "/frequency", 1 ),
  input : nil,
  output : nil,
  conv_coeff : coeff };
  props.globals.getNode(obj.node,1).setValues({ "volts": 0.0, "frequency" : 400.0} );
  return obj;
}

DCACinverterClass.add_input = func( obj ){
  me.input = obj;
}

DCACinverterClass.output = func( obj ){
  me.output = obj;
}

DCACinverterClass.disconnect_from_bus = func{
  me.bus = nil;
}

DCACinverterClass.update = func{
  volts = me.input == nil ? 0.0 : me.input.volts.getValue()*me.conv_coeff;
  me.volts.setValue(volts);
}

ExternalClass = {};

ExternalClass.new = func( name ) {
  obj = { parents : [ExternalClass],
  name : name,
  node :  enode ~ "suppliers/" ~ name ~ "/",
  volts :   props.globals.getNode( enode ~ "suppliers/" ~ name ~ "/volts", 1 ),
  bus : nil,
  ideal_volts : 28.5,
  ideal_amps : 110.0 };
  props.globals.getNode(obj.node,1).setValues({ "volts": 28.5} );
  return obj;
}

ExternalClass.connect_to_bus = func( _bus ){
    me.bus = _bus;
}

ExternalClass.disconnect_from_bus = func{
    me.bus = nil;
}




