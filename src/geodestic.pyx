# cython: cdivision=True
# vim: ft=python

from libc.math cimport sin, cos, asin, sqrt, acos, atan2, abs, tan, atan, pow, M_PI
cimport cython

cpdef double between(double lat1, double lon1, double lat2, double lon2):
    '''
    Based on http://www.ngs.noaa.gov/PUBS_LIB/inverse.pdf using the
    "Inverse Formula" (section 4)

    Code structure poached straight out of the Android source tree
    http://tw.gs/2Xx8D1

    args:
        float, float, float, float
        latitude1, longitude1, latitude2, longitude2

    returns distance between *1 and *2 in km
    '''

    DEF MAXITERS = 20
    cdef int iter_

    cdef double toRadians = (M_PI / 180.0)

    # Convert lat/long to radians
    lat1 *= toRadians
    lon1 *= toRadians
    lat2 *= toRadians
    lon2 *= toRadians

    DEF a = 6378137.0  # WGS84 major axis
    DEF b = 6356752.3142  # WGS84 semi-major axis

    DEF  f = (a - b) / a
    DEF aSqMinusBSqOverBSq = (a * a - b * b) / (b * b)

    cdef:
        double  L = lon2 - lon1
        double  A = 0.0
        double  U1 = atan((1.0-f) * tan(lat1))
        double  U2 = atan((1.0-f) * tan(lat2))

        double  cosU1 = cos(U1)
        double  cosU2 = cos(U2)
        double  sinU1 = sin(U1)
        double  sinU2 = sin(U2)
        double  cosU1cosU2 = cosU1 * cosU2
        double  sinU1sinU2 = sinU1 * sinU2

        double  sigma = 0.0
        double  deltaSigma = 0.0
        double  cosSqAlpha = 0.0
        double  cos2SM = 0.0
        double  cosSigma = 0.0
        double  sinSigma = 0.0
        double  cosLambda = 0.0
        double  sinLambda = 0.0

        double lambda_ = L
        double lambdaOrig
        double t1
        double t2
        double sinSqSigma
        double sinAlpha
        double uSquared
        double B
        double C
        double cos2SMSq
        double delta
        double distance

    for iter_ in range(MAXITERS):
        lambdaOrig = lambda_
        cosLambda = cos(lambda_)
        sinLambda = sin(lambda_)
        t1 = cosU2 * sinLambda
        t2 = cosU1 * sinU2 - sinU1 * cosU2 * cosLambda
        sinSqSigma = pow(t1, 2) + pow(t2, 2)  # t1 * t1 + t2 * t2
        sinSigma = sqrt(sinSqSigma)
        cosSigma = sinU1sinU2 + cosU1cosU2 * cosLambda
        sigma = atan2(sinSigma, cosSigma)

        if sinSigma == 0:
            sinAlpha = 0.0
        else:
            sinAlpha = cosU1cosU2 * sinLambda / sinSigma

        cosSqAlpha = 1.0 - sinAlpha * sinAlpha

        if cosSqAlpha == 0:
            cos2SM = 0.0
        else:
            cos2SM = cosSigma - 2.0 * sinU1sinU2 / cosSqAlpha

        cos2SM = 0.0 if cosSqAlpha == 0 else cosSigma - 2.0 * sinU1sinU2 / cosSqAlpha

        uSquared = cosSqAlpha * aSqMinusBSqOverBSq

        A = 1 + (uSquared / 16384.0) * (4096.0 + uSquared * (-768 + uSquared * (320.0 - 175.0 * uSquared)))
        B = (uSquared / 1024.0) * (256.0 + uSquared * (-128.0 + uSquared * (74.0 - 47.0 * uSquared)))
        C = (f / 16.0) * cosSqAlpha * (4.0 + f * (4.0 - 3.0 * cosSqAlpha))

        cos2SMSq = pow(cos2SM, 2)

        deltaSigma = B * sinSigma * ( cos2SM + (B / 4.0) * (cosSigma * (-1.0 + 2.0 * cos2SMSq) - (B / 6.0) * cos2SM * (-3.0 + 4.0 * sinSigma * sinSigma) * (-3.0 + 4.0 * cos2SMSq)))

        lambda_ = L + (1.0 - C) * f * sinAlpha * (sigma + C * sinSigma * (cos2SM + C * cosSigma * (-1.0 + 2.0 * cos2SM * cos2SM)))

        delta = (lambda_ - lambdaOrig) / lambda_

        if (abs(delta) < 1.0e-12):
            break

    distance = (b * A * (sigma - deltaSigma))

    return distance
