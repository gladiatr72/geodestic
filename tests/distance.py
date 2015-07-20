# pylint: disable=missing-docstring, invalid-name

import unittest

import geodestic as geodestic_
from geographiclib.geodesic import Geodesic

def check(*args):
    a1 = Geodesic.WGS84.Inverse(*args)
    a2 = geodestic_.between(*args)
    return abs(a1['s12'] - a2)

class TestDistance(unittest.TestCase):

    def test_intra_nw_hemisphere(self):
        res = check(49.950832, -125.270833, 32.896828, -97.037997)
        self.assertTrue(res < 0.01)

    def test_inter_northern_hemisphere(self):
        res = check(39.297606, -94.713905, 55.89, 10.62)
        self.assertTrue(res < 0.01)

    def test_inter_western_hemisphere(self):
        res = check(44.9346225, -93.0603424, -26.06245, -65.932095)
        self.assertTrue(res < 0.01)

    def test_nw_se_hemisphere(self):
        res = check(47.613801, -122.354019, -22.291945, 119.437225)
        self.assertTrue(res < 0.01)

    def test_pole_to_pole(self):
        res = check(0, 0, -90, -0.01)
        self.assertTrue(res < 0.01)

if __name__ == '__main__':
        unittest.main()
