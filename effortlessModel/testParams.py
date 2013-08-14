
import numpy as np

class personParams(object):
    def __init__(self):
    	#credit risk
        self.credit_score = 700 # FICO score
        self.credit_guess = 8.0 #
        self.time_in_home = 10.0 # time in home in years
        ## Population and technology
        self._pop0 = 6514. # 2005 world population millions
        self._gpop0 = .35 # growth rate of population per decade
        self.popasym = 8600. # asymptotic population
        self._a0 = .02722 # Initial level of total factor productivity
        self._ga0 = .092 # Initial growth rate for technology per decade
        self.dela = .1 # Decline rate of technological change per decade
        self.dk = .100 # Depreciation rate on capital per year
        self._gama = .300 # Capital elasticity in production function
        self._q0 = 61.1 # 2005 world gross output trill 2005 US dollars
        self._k0 = 137. # 2005 value capital trill 2005 US dollars
        ## Emissions

class homeParams(object):
	def __init__(self):

class econParams(object):
	def __init__(self):
		self.electric_rate_increase = .05 #yearly average increase in utility price, consider bringing in Excel projectsion

