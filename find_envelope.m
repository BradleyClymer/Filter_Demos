function [ y_out ]  = find_envelope( x_in , y_in )
%   find_envelope.m, by Bradley J. Clymer
%   function to find the envelope of a timeseries maximum,
%   using cubic spline interpolation; run with no arguments for a
%   demonstration. 
if nargin == 0
    clc
    x_in    = linspace( 0 , 50*pi , 1500 )'                                                         ;
    y_in    = cos( x_in / 20 ) .* ( exp( ( x_in / max( x_in ) ) ) - 1 ) .* sin( x_in )              ;
    if exist( 'f_fig' , 'var' )
        delete( f_fig ) %#ok<NODEF>
    end
    f_fig   = figure                                                                                ;
end
x_in    = x_in( : )                                                                                 ;
y_in    = y_in( : )                                                                                 ;
if nargin == 0
    plot( x_in , [ cos( x_in / 5 ) ,                                                                ...
                 ( exp( ( x_in / max( x_in ) ) ) - 1 ) ,                                            ...
                   sin( x_in ) ,                                                                    ...
                   y_in ] ,                                                                         ...
                   '-.' , 'LineWidth' , 2 )                                                      	;
    hold on
    axis tight
end
envelope_points     = [ 0 ; diff( sign( diff( y_in ) ) ) ; 0 ] == -2                                ;
envelope_values     = y_in( envelope_points )                                                       ;
x_out               = x_in( envelope_points )                                                       ;
y_out               = interp1( x_out , envelope_values , x_in , 'spline' )                          ;

if nargin == 0
    plot( x_in, y_out , 'k' , 'LineWidth' , 1 )
    legend( { 'Cosine Term' , 'Exponential Term' , 'Sine Term' , 'Total' , 'Interpolated Envelope' }...
            , 'Location' , 'Northwest' )
end

end