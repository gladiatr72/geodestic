# geodistance

This module provides a single function: between()

It takes four floats corresponding to two latitude/longitude sets given in decimal degrees and returns a value that corresponds to the length of the geodesic arc between those two coordinates.  The bearing calculation bits of the original source are not a part of this module.

At some point I'd like to enhance this module to accept a list of coordinates (perhaps) mapped to a memory view for faster batch processing.  

Benched against geopy/cpython with a set of 5000 pairs of coordinates, the cython variety comes in at 2.52ms vs 116ms cpython.  (final version of this pending pypy compilation)


http://tw.gs/2Xyci3
