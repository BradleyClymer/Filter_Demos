clear, close all hidden
set( 0 , 'DefaultAxesXgrid' , 'on' , 'DefaultAxesYgrid' , 'on', 'DefaultAxesZgrid' , 'on')
set( 0 , 'DefaultFigureUnits' , 'Normalized' )
set( 0 , 'DefaultFigurePosition' , [ 0.1 0.1 0.8 0.8 ] )
set( 0 , 'DefaultLineLinesmoothing' , 'on' ) 
set( 0 , 'DefaultLineLinewidth' , 1 )
load handel;
y_short     = y( 2000 : 22000 )  ;
y_diff      = diff( y_short )    ;

% sound( y_short , Fs )

sp( 1 ) = subplot( 211 )
plot( y_short )
sp( 2 ) = subplot( 212 ) 
plot( y_diff ) 
axis tight
linkaxes( sp ) 
sound( y_diff ) 
