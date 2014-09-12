function signal_differentiation
clear, close all hidden, clc
set( 0 , 'DefaultAxesXgrid' , 'on' , 'DefaultAxesYgrid' , 'on', 'DefaultAxesZgrid' , 'on')
set( 0 , 'DefaultFigureUnits' , 'Normalized' )
set( 0 , 'DefaultFigurePosition' , [ 1.1 0.1 0.8 0.8 ] )
set( 0 , 'DefaultLineLinesmoothing' , 'on' ) 
set( 0 , 'DefaultLineLinewidth' , 1 )



                  load handel                     	;
% Fs              = 1                  
% y               = 1 * rand( size( y ) ) - 0.5     	;
y               = medfilt2( y , [ 20 , 1 ] )        ;
period          = 1 / Fs                            ;
time            = ( 0 : ( numel( y )-1 ) ) * period ;
start           = 2000                              ;
length          = 2 ^ 14                            ;
range_end       = start + length - 1                ; 
range           = start : range_end                 ;
y_short         = y( range )                        ;
y_diff          = [ 0 ; diff( y_short )  ]          ;
[ fss , yss ]	= signal_fft( Fs , y_short )        ;
[ fds , yds ]	= signal_fft( Fs , y_diff )         ;

%   Plot input signal
sp( 1 ) = subplot( 321 )                    ;
plot( time( range ) , y_short )
hold on                                
title( 'Original Audio Signal' )
xlabel( 'Time (s)' )
ylabel( 'Amplitude' ) 
axis tight
ylim( [ -1 1 ] )

%   Plot differentiated signal
sp( 2 ) = subplot( 322 )                    ;
plot( time( range ) , y_diff ) 
title( 'Differentiated Audio Signal' )
xlabel( 'Time (s)' )
ylabel( 'Amplitude' ) 

%   Plot original spectrum
sp( 3 ) = subplot( 323 )                    ;
plot( fss , yss , '-r' )    
hold on
envelope    = find_envelope( fss , find_envelope( fss , yss ) )   ;
plot( fss , envelope , 'k' , 'LineWidth' , 1 )  
title( 'Original Spectrum' )
xlabel( 'Frequency, Hz' )
ylabel( 'Amplitude' ) 

%   Plot differentiated spectrum
sp( 4 ) = subplot( 324 )                    ;
plot( fds , yds , '-g' )                      
hold on
envelope    = find_envelope( fss , find_envelope( fss , yds ) )   ;
plot( fss , envelope , 'k' , 'LineWidth' , 1 )  
title( 'Differentiated Spectrum' )
xlabel( 'Frequency, Hz' )
ylabel( 'Amplitude' ) 

linkaxes( sp( 1:2 ) ) 
linkaxes( sp( 3:4 ) )
axis tight

%   Plot difference of spectrum
sp( 5 ) = subplot( 325 )                                                ;
plot( fss , yss - yds , 'r' ) 
hold on
data        = medfilt2( yss - yds , [ 55 , 1 ] )                      	;
envelope    = find_envelope( fss , find_envelope( fss, data ) )      	;
fss( find( [ 0 ; diff( sign( envelope ) ) ] == -2 ) )
% envelope    = medfilt2( envelope( 15 , 1 ) )                      	  ;
plot( fss , envelope , 'k' , 'LineWidth' , 1 )  
title( 'Original Spectrum - Differentiated Spectrum' )
xlabel( 'Frequency, Hz' )
ylabel( 'Amplitude' )

%   Plot spectrum of differences
sp( 6 ) = subplot( 326 )                                                ;
[ freq , diff_spec ]    = signal_fft( Fs , y_short - y_diff )           ;
plot( freq , diff_spec , 'g' )
hold on
envelope    = find_envelope( fss , find_envelope( fss , diff_spec ) )   ;
plot( fss , envelope , 'k' , 'LineWidth' , 1 )  
linkaxes( sp( 3:6 ) )
ylim( [ -0.001 0.02 ] )
title( 'Spectrum of (Original Signal - Differentiated Signal)' )
xlabel( 'Frequency, Hz' )
ylabel( 'Amplitude' )

%   Play Audio
zs              = zeros( size( y_short ) )                              ;
sub             = y_short - y_diff                                      ;
sound_compare   = ( [ y_short ; sub ; y_diff ; sub  ] )                 ;
bp              = [ 0 100  ] + 400                                      
400 * 2 ^ ( 4/12 )
passband        = ( fss > bp( 1 ) ) & ( fss < bp( 2 ) )                 ;
filt_spectrum   = fss                                                   ;
filt_spectrum( ~passband ) = 0                                          ;
filtered        = ( ifft( filt_spectrum ) )                             ;
% filtered        = filtered( 1 : 8192/2 )                                ;
figure
subplot( 131 )
plot( fss , signal_fft( Fs , filtered ) )
title( 'Filtered spectrum' ) 
subplot( 132 ) 
plot( [ real( filtered )' imag( filtered )' ] )
sound( [ real( filtered )' imag( filtered )' ] ) 
subplot( 133 ) 
plot( fss , passband  )
% sound( sound_compare ) 

% export_fig handel_median_20_samples

end

function [freq,abs_amp] = signal_fft( Fs , y_in )
L           = numel( y_in )                                         ;	% Length of signal
num_fft     = ( 2 ^ nextpow2( L ) )                                 ;
Y           = fft( y_in , num_fft ) / L                             ;
freq        = Fs / 2 * linspace( 0 , 1 , num_fft/2 + 1 )            ;
abs_amp     = 2 * abs( Y( 1 : ( num_fft/2 + 1 ) ) )                 ;
end