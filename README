# geodestic

This module provides a single function: between()

It takes four floats corresponding to two latitude/longitude sets given in decimal degrees and returns a value that corresponds to the length of the geodesic distance between those two coordinates.  The bearing calculation bits of the original source are not a part of this module. 

The tests run against geographiclib. It is thought to be the most precise and speedy open source library for GIS calulations. There is an accompanying python implementation (not bindings) written by the author of the C++ library. (_pip install geographiclib_) It is quite a bit slower than the C++ implementation and my cffi-fu is not quite up to wrapping it in way that I would feel confident using it. 

Thanks to the Android team the for the clear expression of the inversion forumla. (http://tw.gs/2Xyci3)
