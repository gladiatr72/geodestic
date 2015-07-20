
import geodestic
import geographiclib.geodesic
import timeit

def a1():
    return geographiclib.geodesic.Geodesic.WGS84.Inverse(38.9666995, -95.2296073, 39.1268547, -100.8693174)['s12']

def a2():
    return geodestic.between(38.9666995, -95.2296073, 39.1268547, -100.8693174)

print 'geographiclib: {:,}m'.format(a1())
print 'geodestic: {:,}m'.format(a2())

print 'difference: {:.6f}m'.format(a2() - a1())



