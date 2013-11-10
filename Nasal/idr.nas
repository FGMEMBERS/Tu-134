# NASAL instruments for TU-154B
# Yurik V. Nikiforoff, yurik.nsk@gmail.com
# Novosibirsk, Russia
# jun 2007, 2013
#
# Updated Helijah 2013

# =============================== IDR-1 support =============================
idr_capt_handler = func
{
  settimer( idr_capt_handler, 0 );
  var distance = 0.0;
  var caged = 1;
  if( getprop("tu134/switches/capt-idr-selector") == nil )
      setprop("tu134/switches/capt-idr-selector", 0.0 );
  if( getprop("tu134/switches/capt-idr-selector") == 0 )
  {
    if( getprop( "instrumentation/nav[0]/in-range") == 1 )
    {
      if( (getprop( "instrumentation/nav[0]/nav-loc") == 0 ) # not ILS (VOR)
           or (getprop( "instrumentation/nav[0]/dme-in-range") == 1 ) # ILS with DME
        ) 
      {
        setprop("tu134/instrumentation/idr-1[0]/caged-flag",0 );
        distance = getprop("instrumentation/nav[0]/nav-distance");     
        caged = 0;
      }
      else distance = 0.0;
    }
  }
  if( getprop("tu134/switches/capt-idr-selector") == 1 )
  {
    if( getprop( "instrumentation/nav[2]/in-range") == 1 )
    {
      if( (getprop( "instrumentation/nav[2]/nav-loc") == 0 ) # not ILS
          or (getprop( "instrumentation/nav[2]/dme-in-range") == 1 ) # ILS with DME
        )
      {
        setprop("tu134/instrumentation/idr-1[0]/caged-flag",0 );
        distance = getprop("instrumentation/nav[2]/nav-distance");     
        caged = 0;
      }
    }
    else distance = 0.0;
  }
  if( getprop("tu134/switches/capt-idr-selector") == 2 )
  {
    if( getprop( "instrumentation/nav[1]/in-range") == 1 )
    {
      if( (getprop( "instrumentation/nav[1]/nav-loc") == 0 )             # not ILS
      or (getprop( "instrumentation/nav[1]/dme-in-range") == 1 )         # ILS with DME
      )
      {
        setprop("tu134/instrumentation/idr-1[0]/caged-flag",0 );
        distance = getprop("instrumentation/nav[1]/nav-distance");     
        caged = 0;
      }
    }
    else  distance = 0.0;
  }
  setprop("tu134/instrumentation/idr-1[0]/caged-flag", caged );

  # Translate distance to pkp.
  # Added by Yurik jun 2013
  if( getprop( "tu134/instrumentation/distance-to-pnp" ) )               # Absent in real life
  {
    if( getprop("tu134/instrumentation/idr-1[0]/caged-flag" ) == 0.0 ) 
    { # Set distance from IDR
      setprop( "tu134/instrumentation/pnp[0]/distance-km", distance/1000.0 );
      setprop( "tu134/instrumentation/pnp[1]/distance-km", distance/1000.0 );
      setprop( "tu134/instrumentation/pnp[0]/blanker-dkm", 0 );
      setprop( "tu134/instrumentation/pnp[1]/blanker-dkm", 0 );
    }
    else
    {                                                                    # Check if NVU ready and set distance from there.
      if( getprop("tu134/systems/nvu/selector" ) == 1 )
      { # selected NVU block 1
        setprop( "tu134/instrumentation/pnp[0]/distance-km",
        abs( getprop("fdm/jsbsim/instrumentation/aircraft-integrator-s-1")/1000.0 ) );
        setprop( "tu134/instrumentation/pnp[1]/distance-km",
        abs( getprop("fdm/jsbsim/instrumentation/aircraft-integrator-s-1")/1000.0 ) );
      }
      else
      {                                                                  # selected NVU block 0
        setprop( "tu134/instrumentation/pnp[0]/distance-km",
        abs( getprop("fdm/jsbsim/instrumentation/aircraft-integrator-s-2")/1000.0 ) );
        setprop( "tu134/instrumentation/pnp[1]/distance-km",
        abs( getprop("fdm/jsbsim/instrumentation/aircraft-integrator-s-2")/1000.0 ) );
      }
      if( ( getprop("tu134/systems/nvu/powered" ) == 1 ) and ( getprop("tu134/systems/nvu/serviceable" ) == 1 ) )
      {
        setprop( "tu134/instrumentation/pnp[0]/blanker-dkm", 0 );
        setprop( "tu134/instrumentation/pnp[1]/blanker-dkm", 0 );
      }
      else 
      {
        setprop( "tu134/instrumentation/pnp[0]/blanker-dkm", 1 );
        setprop( "tu134/instrumentation/pnp[1]/blanker-dkm", 1 );
      }
    }
  }
  else
  {
    setprop( "tu134/instrumentation/pnp[0]/blanker-dkm", 1 );
    setprop( "tu134/instrumentation/pnp[1]/blanker-dkm", 1 );
  }
  if( distance == nil )
  {
    setprop("tu134/instrumentation/idr-1[0]/caged-flag",1 ); return;
  } 
  distance = distance/10.0; # to dec meters, it need for correct work of digit wheels
  setprop("tu134/instrumentation/idr-1[0]/indicated-wheels_dec_m", 
  (distance/10.0) - int( distance/100.0 )*10.0 );
  setprop("tu134/instrumentation/idr-1[0]/indicated-wheels_hund_m", 
  (distance/100.0) - int( distance/1000.0 )*10.0 );
  setprop("tu134/instrumentation/idr-1[0]/indicated-wheels_ths_m", 
  (distance/1000.0) - int( distance/10000.0 )*10.0 );
  setprop("tu134/instrumentation/idr-1[0]/indicated-wheels_decths_m", 
  (distance/10000.0) - int( distance/100000.0 )*10.0 );
}

idr_capt_handler();
