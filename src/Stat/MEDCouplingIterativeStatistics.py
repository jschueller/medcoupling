import math

try:
    import openturns as ot

    have_ot = True
except ImportError:
    have_ot = False

from abc import ABC, abstractmethod
import numpy as np
import copy


# the following code is borrowed from
# https://github.com/IterativeStatistics/BasicIterativeStatistics


class _AbstractIterativeStatistics(ABC):
    """
    A basic abstract class to compute iteratives statistics.
    """

    def __init__(self, dim: int, state: object = None):
        self.dimension = dim
        if state is None:
            self.state = np.zeros(dim)
            self.iteration = 0
        else:
            self.load_from_state(state)

    @abstractmethod
    def increment(self, data: np.array):
        """
        An abstract method to implement. It must contain the algorithm to compute iteratively statistics.
        """
        raise Exception("Not implemented method")

    def save_state(self):
        """
        A method that save the current state.
        """
        return {"iteration": self.iteration, "state": self.state}

    def load_from_state(self, state: object):
        """
        A method that load the current state
        """
        self.iteration = state.get("iteration", 0)
        self.state = state.get("state", None)

    def get_stats(self):
        """
        A method that return the current state
        """
        return self.state

    def get_iteration(self):
        """
        A method that return the current iteration value
        """
        return self.iteration


class _IterativeMean(_AbstractIterativeStatistics):
    """
    Iterative Mean
    """

    def increment(self, data):
        self.iteration += 1
        self.state += (data - self.state) / float(self.iteration)
        # logger.debug(f'increment= {self.increment}, mean= {self.state}')


class _IterativeShiftedMean(_AbstractIterativeStatistics):
    """
        Iterative Mean with a shift in the data
    """
    def __init__(self, dim : int = 1, state: object = None):
        self.previous_shift = None
        super().__init__(dim, state)


    def increment(self, data, shift: np.array):
        self.iteration += 1
        if self.iteration == 1 : # Initialization
            self.state += data - shift 
        else :
            # logger.info(f'------------ data: {data}')
            self.state *= (1. - 1./self.iteration)
            self.state += (data - self.previous_shift)/self.iteration  + (self.previous_shift - shift)

        # update the shift
        self.previous_shift = copy.deepcopy(shift)

    def save_state(self):
        """
            An abstract method to implement. It save the current state of the objects.
        """
        state = super().save_state()
        state['previous_shift'] = self.previous_shift
        return state

    def load_from_state(self, state: object):
        """
            It load the current state of the object.
        """
        super().load_from_state(state)
        self.previous_shift = state.get('previous_shift', None)


class _IterativeVariance(_AbstractIterativeStatistics):
    def __init__(self, dim: int = 1, state: object = None):
        if state is None:
            self.mean = _IterativeMean(dim)
            self.sumOfCenteredSquares = np.zeros(dim)
        super().__init__(dim, state)

    def increment(self, data):
        self.iteration += 1
        if self.iteration > 1:
            self.sumOfCenteredSquares += (
                (self.iteration - 1) * (data - self.mean.get_stats()) ** 2 / self.iteration
            )

        # update mean
        self.mean.increment(data)

        # compute variance
        if self.iteration > 1:
            self.state = self.sumOfCenteredSquares / (self.iteration - 1)
        # logger.debug(f'increment= {self.increment}, variance= {self.state}')

    def get_variance(self):
        return self.state

    def get_mean(self):
        return self.mean.get_stats()

    def save_state(self):
        """
        An abstract method to implement. It save the current state of the objects.
        """
        state = super().save_state()
        state["mean"] = self.mean.save_state()
        state["sumOfCenteredSquares"] = self.sumOfCenteredSquares
        return state

    def load_from_state(self, state: object):
        """
        It load the current state of the object.
        """
        super().load_from_state(state)
        self.mean = _IterativeMean(self.dimension, state.get("mean"))
        self.sumOfCenteredSquares = state.get("sumOfCenteredSquares")


class _IterativeCovariance(_AbstractIterativeStatistics):
    def __init__(self, dim: int = 1, state: object = None):
        self.mean_1 = _IterativeMean(dim)
        self.mean_2 = _IterativeMean(dim)
        super().__init__(dim, state)

    def increment(self, data_1, data_2):
        # update mean
        self.iteration += 1
        prev_mean_1 = copy.deepcopy(self.mean_1.get_stats())
        prev_mean_2 = copy.deepcopy(self.mean_2.get_stats())
        self.mean_1.increment(data_1)
        self.mean_2.increment(data_2)

        # update covariance
        if self.iteration > 1:
            self.state = self.state * (self.iteration - 2)
            x = np.multiply(data_1 - prev_mean_1, data_2 - prev_mean_2)
            diff_mean = np.multiply(
                prev_mean_1 - self.mean_1.get_stats(),
                prev_mean_2 - self.mean_2.get_stats(),
            )
            self.state = self.state + x - diff_mean * self.iteration
            self.state = self.state / (self.iteration - 1)

    def getCovariance(self):
        return self.state

    def get_mean1(self):
        return self.mean_1.get_stats()

    def get_mean2(self):
        return self.mean_2.get_stats()

    def save_state(self):
        """
        An abstract method to implement. It save the current state of the objects.
        """
        state = super().save_state()
        state["mean_1"] = self.mean_1.save_state()
        state["mean_2"] = self.mean_2.save_state()
        return state

    def load_from_state(self, state: object):
        """
        It load the current state of the object.
        """
        super().load_from_state(state)
        self.mean_1 = _IterativeMean(self.dimension, state=state.get("mean_1", None))
        self.mean_2 = _IterativeMean(self.dimension, state=state.get("mean_2", None))


class IterativeMoments:
    """
    Compute statistics over fields.
    
    Parameters
    ----------
    enable_mean : bool, optional
        Whether to aggregate mean
        Default is True
    enable_variance : bool, optional
        Whether to aggregate variance
        Default is True
    enable_covariance : bool, optional
        Whether to aggregate covariance
        Default is True
    """

    def __init__(self, enable_mean=True, enable_variance=True, enable_covariance=True):
        self._dim = None
        self._size = None
        self._enable_mean = enable_mean
        self._enable_variance = enable_variance
        self._enable_covariance = enable_covariance

    def increment(self, field):
        """
        Increment state.

        Parameters
        ----------
        field : medcoupling.MEDCouplingFieldDouble
            Field to compute statistics from
        """
        values = field.getArray()

        if self._dim is None:
            self._dim = values.getNumberOfComponents()
            self._size = values.getNumberOfTuples()
            if have_ot:
                self._agg_mean = [ot.IterativeMoments(1, self._dim) for k in range(self._size)] if self._enable_mean else None
                self._agg_variance = [ot.IterativeMoments(2, self._dim) for k in range(self._size)] if self._enable_variance else None
            else:
                self._agg_mean = [_IterativeMean(dim=self._dim) for k in range(self._size)] if self._enable_mean else None
                self._agg_variance = [_IterativeVariance(dim=self._dim) for k in range(self._size)] if self._enable_variance else None

            if self._enable_covariance:
                n_tri = (self._dim * (self._dim + 1) // 2)
                self._agg_covariance = [[_IterativeCovariance(dim=1) for i in range(n_tri)] for k in range(self._size)]
            else:
                self._agg_covariance = None

        if values.getNumberOfComponents() != self._dim:
            raise ValueError(f"Incorrect number of components {values.getNumberOfComponents()} expected {self._dim}")
        if values.getNumberOfTuples() != self._size:
            raise ValueError(f"Incorrect number of tuples {values.getNumberOfTuples()} expected {self._size}")
        for k in range(self._size):
            tk = values.getTuple(k)
            if self._enable_mean:
                self._agg_mean[k].increment(tk)
            if self._enable_variance:
                self._agg_variance[k].increment(tk)
            if self._enable_covariance:
                for i in range(self._dim):
                    for j in range(i + 1):
                        self._agg_covariance[k][i * (i + 1) // 2 + j].increment(tk[i], tk[j])

    def mean(self):
        """
        Mean.

        Returns
        -------
        mean : numpy.array of shape (n, d)
            Mean field
        """
        if self._agg_mean is None:
            raise ValueError(f"No data aggregated")

        mean = np.zeros((self._size, self._dim))
        for i in range(self._size):
            if have_ot:
                mean[i] = self._agg_mean[i].getMean()
            else:
                mean[i] = self._agg_mean[i].get_stats()
        return mean

    def variance(self):
        """
        Variance.

        Returns
        -------
        variance : numpy.array
            Variance per component
        """
        if self._agg_variance is None:
            raise ValueError(f"No data aggregated")

        variance = np.zeros((self._size, self._dim))
        for i in range(self._size):
            if have_ot:
                variance[i] = self._agg_variance[i].getVariance()
            else:
                variance[i] = self._agg_variance[i].get_stats()
        return variance

    def stddev(self):
        """
        Standard deviation.

        Returns
        -------
        stddev : numpy.array of shape (n, d)
            Standard deviation per component
        """
        return np.sqrt(self.variance())

    def covariance(self):
        """
        Compute the variance-covariance matrix.

        Returns
        -------
        cov : numpy.array of shape (n, d, d)
            Variance-covariance matrix
        """
        if self._agg_covariance is None:
            raise ValueError(f"No data aggregated")

        covariance = np.zeros((self._size, self._dim, self._dim))
        for k in range(self._size):
            for i in range(self._dim):
                for j in range(i + 1):
                    covij = self._agg_covariance[k][i * (i + 1) // 2 + j].get_stats()[0]
                    covariance[k, i, j] = covij
                    if i != j:
                        covariance[k, j, i] = covij
        return covariance


class AbstractExperiment(ABC):
    def __init__(self, nb_parms: int, nb_sim : int, apply_pick_freeze: bool = True, seed : int = 0, second_order: bool = False,  **kwargs) -> None:
        self.seed = seed
        self.nb_sim = nb_sim
        self.nb_parms = nb_parms
        self.apply_pick_freeze = apply_pick_freeze
        self.second_order = second_order

    def generator(self) :
        for _ in range(self.nb_sim):
            sample_A = self.draw()
            if self.apply_pick_freeze:
                sample_B = self.draw()
                sample = self.pick_freeze(sample_A[0], sample_B[0])
            else:
                sample = sample_A[0]
            yield sample

    def pick_freeze(self, sample_A: np.array, sample_B : np.array) -> np.array:
        """
            Apply the pick-freeze method and construct the set of inputs parameters
        """
        if sample_A is None :
            sample_A = self.draw()[0]
        if sample_B is None :
            sample_B = self.draw()[0]
        sample = np.vstack(([sample_A], [sample_B]))
        for k in range(self.nb_parms):
            sample_Ek = copy.deepcopy(sample_A)  
            sample_Ek[k] = sample_B[k]
            sample = np.vstack( (sample, sample_Ek))
        
        if self.second_order :
            for k in range(self.nb_parms):
                sample_Ck = copy.deepcopy(sample_B)  
                sample_Ck[k] = sample_A[k]
                sample = np.vstack( (sample, sample_Ck))
        return sample 

    @abstractmethod
    def draw(self) -> np.array:
        pass


def _multi_dim_dotproduct(data_1: np.array, data_2: np.array, dim: int = 1):
    if dim == 1 :
        return np.dot(data_1, data_2)
    return np.array([np.dot(data_1[:,k], data_2[:,k]) for k in range(dim)])


class _IterativeDotProduct(_AbstractIterativeStatistics):
    def __init__(self, dim : int = 1, iterative_shifted_mean_1 : _IterativeShiftedMean = None, 
                        iterative_shifted_mean_2 : _IterativeShiftedMean = None, state: object = None):
        """
            Compute iteratively the formula sum_k=0:N (A_k - shift_N)(B_k - shift_N)/(N-1)
            iterative_shifted_mean_1 (IterativeShiftedMean) : add an external iterative shifted mean. If it is not None, the mean will not be updated into this class
        """
        self.previous_shift = None

        if iterative_shifted_mean_1 is None :
            self.iterative_shifted_mean_1 = _IterativeShiftedMean(dim)
            self.external_mean_1 = False
        else :
            self.iterative_shifted_mean_1 = iterative_shifted_mean_1
            self.external_mean_1 = True

        if iterative_shifted_mean_2 is None :
            self.iterative_shifted_mean_2 = _IterativeShiftedMean(dim)
            self.external_mean_2 = False
        else :
            self.iterative_shifted_mean_2 = iterative_shifted_mean_2
            self.external_mean_2 = True

        super().__init__(dim, state)
        self.data_1 = None
        self.data_2 = None

    def increment(self, data_1, data_2, shift):
        self.iteration += 1
        
        if self.iteration == 1 :
            self.data_1 = data_1
            self.data_2= data_2
        elif self.iteration == 2 :
            if self.dimension == 1 :
                self.data_1 = np.array([self.data_1, data_1])
                self.data_2= np.array([self.data_2, data_2])
            else :
                self.data_1 = np.vstack((self.data_1, data_1))
                self.data_2 = np.vstack((self.data_2, data_2))
            self.state = _multi_dim_dotproduct(self.data_1 - shift, self.data_2 - shift, self.dimension)
            del self.data_1 , self.data_2
        else :
            diff_shift = self.previous_shift - shift
            self.state *= (1 - 1/(self.iteration - 1))
            self.state += np.multiply(data_1 - self.previous_shift, data_2 - self.previous_shift)/(self.iteration - 1)
            val = self.iterative_shifted_mean_1.get_stats() + self.iterative_shifted_mean_2.get_stats()
            val +=  diff_shift + (data_1 + data_2 - shift - self.previous_shift)/(self.iteration - 1)
            self.state += val * diff_shift
            
            
        # Update iterative shifted mean if not external
        if not self.external_mean_1 :
            self.iterative_shifted_mean_1.increment(data_1, shift)

        if not self.external_mean_2 :
            self.iterative_shifted_mean_2.increment(data_2, shift)
        
        self.previous_shift = copy.deepcopy(shift)


    def get_mean_1(self):
        return self.iterative_shifted_mean_1.get_stats()

    def get_mean_2(self):
        return self.iterative_shifted_mean_2.get_stats()

    def save_state(self):
        """
            An abstract method to implement. It save the current state of the objects.
        """
        state = super().save_state()
        state['previous_shift'] = self.previous_shift
        if not self.external_mean_1 :
            state['external_mean_1'] = self.iterative_shifted_mean_1.save_state()
        if not self.external_mean_2 :
            state['external_mean_2'] = self.iterative_shifted_mean_2.save_state()
        return state
        

    def load_from_state(self, state: object):
        """
            It load the current state of the object.
        """
        super().load_from_state(state)
        self.previous_shift = state.get('previous_shift')
        if state.get('external_mean_1', None) is not None :
            self.external_mean_1 = False
            self.iterative_shifted_mean_1 = IterativeShiftedMean(self.dimension, state.get('external_mean_1'))
        if state.get('external_mean_2', None) is not None :
            self.external_mean_2 = False
            self.iterative_shifted_mean_2 = IterativeShiftedMean(self.dimension, state.get('external_mean_2'))


class _IterativeAbstractSensitivity(_AbstractIterativeStatistics):
    """
        Abstract class to compute the first, second and total sensitivity indices
    """

    def __init__(self, nb_parms : int, dim: int = 1, 
                        second_order: bool = False, name: str = "", state: object = None) -> None:
        """
            nb_parms (int) : number of input variables
            dim (int) : output size
            second_order (bool) : a boolean indicating if the second order must be computed or not. 
        """
        self.name : str = name
        self.nb_parms : int = nb_parms
        self.second_order : bool = second_order 

        if state is None :
            self.mean_tot : IterativeMean = _IterativeMean(dim)
            self.mean_tot_iteration : int = 0
            self.var_A: AbstractIterativeStatistics = _IterativeVariance(dim)

            if second_order or name == SALTELLI:
                self.iterative_shifted_mean_A = _IterativeShiftedMean(dim)
                self.iterative_shifted_mean_B = _IterativeShiftedMean(dim)
                self.iterative_shifted_mean_E = [_IterativeShiftedMean(dim) for _ in range(nb_parms)]

            if second_order :
                self.dotproduct_AB = _IterativeDotProduct(dim, iterative_shifted_mean_1 = self.iterative_shifted_mean_A, iterative_shifted_mean_2 = self.iterative_shifted_mean_B)
                self.dotproduct_EC = [[_IterativeDotProduct(dim, iterative_shifted_mean_1 = self.iterative_shifted_mean_E[i]) for _ in range(nb_parms)] for i in range(nb_parms)]

        super().__init__(dim, state)


    def _increment_variance(self, data : np.array) -> None: 
        """
            data (np.array) : input data
            Function that increments the variance of sample A.
        """       
        self.var_A.increment(data[0])
        
    def getIteration(self) -> int:
        """
            Get the current iteration index.
        """
        return self.iteration

    def getFirstOrderIndices(self) -> np.array:
        """
            Compute the self.nb_parms first order sensitivity indices
        """
        if self.iteration > 1 :
            return self._compute_varianceI()/self.var_A.get_stats()[:,None]
        else :
            return None
 
    def getSecondOrderIndices(self) -> np.array:
        """
            Compute the self.nb_parms second order sensitivity indices
        """
        if self.iteration > 1 and self.second_order :   
            first_order = self._compute_varianceI()
            val = np.zeros((self.dimension, self.nb_parms, self.nb_parms))
            
            for i in range(self.nb_parms):
                for j in range(self.nb_parms):
                    val[:, i,j] = self.dotproduct_EC[i][j].get_stats() - first_order[:,i] - first_order[:,j] 
            val += self.dotproduct_AB.get_stats()[:, None, None] * (1. - 1./self.iteration)
            return val/self.var_A.get_stats()[:, None, None]
        else :
            return None

    def getTotalOrderIndices(self) -> np.array :
        """
            Compute the self.nb_parms total order sensitivity indices
        """
        if self.iteration > 1 :
            return np.divide(self._compute_VTi(),self.var_A.get_stats()[:,None])
        else :
            return None

    def increment(self, data : np.array) -> None :
        """
            Function that applies the iterative formula to increment the first and total order indices.
        """
        self.iteration += 1
        # Update the total mean
        if self.second_order or self.name == SALTELLI:
            self._update_global_mean(data)

        # Update the variance (sample A)
        self._increment_variance(data)

        # Update the specific increment data
        self._increment(data)


        if self.second_order :
            nb_required_sim = (2+ 2*self.nb_parms)
            if len(data) < nb_required_sim:
                raise Exception(f'The sample size must have {nb_required_sim} rows to compute the second order term.')
            else :
                self._increment_dotproduct(data)
        
        # Update all the shifted mean 
        if self.second_order or self.name == SALTELLI :
            self.iterative_shifted_mean_A.increment(data[0], shift = self.mean_tot.get_stats())
            self.iterative_shifted_mean_B.increment(data[1], shift = self.mean_tot.get_stats())
            for i in range(self.nb_parms):
                self.iterative_shifted_mean_E[i].increment(data[2:(2+self.nb_parms)][i], shift = self.mean_tot.get_stats())


    def _increment(self, data : np.array) -> None :
        """
            Function that applies the specific iterative formula to increment the first and total order indices.
        """
        raise Exception('Not implemented method')


    def _increment_dotproduct(self,data : np.array) -> None :
        """
            data (np.array) : a (self.nb_sim size, self.nb_parms) np.array vector
            Internal method that increments the dot products order sensitivity value.
        """

        # Update EC dot product and E iterative mean
        sample_E = data[2:2+self.nb_parms]
        sample_C = data[2+self.nb_parms:]
        for i in range(self.nb_parms) :
            for j in range(self.nb_parms):
                self.dotproduct_EC[i][j].increment(sample_E[i], sample_C[j], shift = self.mean_tot.get_stats())    
        
        # Update AB dot product
        self.dotproduct_AB.increment(data[0], data[1], shift = self.mean_tot.get_stats())
    
    def _update_global_mean(self, data : np.array) -> None :
        if self.iteration -1 == self.mean_tot_iteration : 
            # Update the global mean of the system
            for d in data :
                self.mean_tot.increment(d)
            self.mean_tot_iteration += 1 

    def _compute_varianceI(self) -> None:
        """
            Function that computes the variance V_i
        """
        raise Exception('Not implemented method')

    def _compute_VTi(self) -> None:
        """
            Function that computes the total variance V[Y] - V_-i
        """
        raise Exception('Not implemented method')

    def save_state(self):
        """
            An abstract method to implement. It save the current state of the objects.
        """
        
        state = {}
        state['iteration'] = self.iteration
        state['mean_tot'] = self.mean_tot.save_state()
        state['mean_tot_iteration'] = self.mean_tot_iteration
        state['var_A'] = self.var_A.save_state()

        if self.second_order or self.name == SALTELLI:
            state['iterative_shifted_mean_A'] = self.iterative_shifted_mean_A.save_state()
            state['iterative_shifted_mean_B'] = self.iterative_shifted_mean_B.save_state()
            state['iterative_shifted_mean_E'] = [self.iterative_shifted_mean_E[i].save_state() for i in range(self.nb_parms)]

        if self.second_order :
            state['dotproduct_AB'] = self.dotproduct_AB.save_state()
            state['dotproduct_EC'] = [[self.dotproduct_EC[i][j].save_state() for j in range(self.nb_parms)] for i in range(self.nb_parms)]

        return state

    def load_from_state(self, state: object):
        """
            It load the current state of the object.
        """
        self.iteration = state.get('iteration')
        self.mean_tot = IterativeMean(self.dimension, state.get('mean_tot'))
        self.mean_tot_iteration = state.get('mean_tot_iteration')
        self.var_A = IterativeVariance(self.dimension, state.get('var_A'))

        if self.second_order or self.name == SALTELLI:
            self.iterative_shifted_mean_A = IterativeShiftedMean(self.dimension, state.get('iterative_shifted_mean_A'))
            self.iterative_shifted_mean_B = IterativeShiftedMean(self.dimension, state.get('iterative_shifted_mean_B'))
            self.iterative_shifted_mean_E = [IterativeShiftedMean(self.dimension, s) for s in state.get('iterative_shifted_mean_E')]

        if self.second_order :
            self.dotproduct_AB = _IterativeDotProduct(self.dimension, 
                                                        iterative_shifted_mean_1 = self.iterative_shifted_mean_A, 
                                                        iterative_shifted_mean_2 = self.iterative_shifted_mean_B,
                                                        state= state.get('dotproduct_AB'))
            s = state.get('dotproduct_EC')
            self.dotproduct_EC = [[_IterativeDotProduct(self.dimension, 
                                    iterative_shifted_mean_1 = self.iterative_shifted_mean_E[i], state=s[i][j]) for j in range(self.nb_parms)] for i in range(self.nb_parms)]


SALTELLI = 'Saltelli'
class _IterativeSensitivitySaltelli(_IterativeAbstractSensitivity):
    """
    Estimates the Sobol indices iteratively based on the Saltelli formula.
    """
    def __init__(self, nb_parms: int, dim: int = 1, second_order: bool = False, state: object = None):
        super().__init__(nb_parms = nb_parms, dim = dim, 
                            second_order=second_order, name = SALTELLI, state=state)
        
        self.dotproduct_AE = [_IterativeDotProduct(dim, iterative_shifted_mean_1 = self.iterative_shifted_mean_A, iterative_shifted_mean_2 = self.iterative_shifted_mean_E[i]) for i in range(self.nb_parms)]
        self.dotproduct_BE = [_IterativeDotProduct(dim, iterative_shifted_mean_1 = self.iterative_shifted_mean_B, iterative_shifted_mean_2 = self.iterative_shifted_mean_E[i]) for i in range(self.nb_parms)]
        
       
    def _increment(self, data):
        sample_E = data[2:(2 + self.nb_parms)]
        for p in range(self.nb_parms):
            self.dotproduct_AE[p].increment(data[0],sample_E[p], shift = self.mean_tot.get_stats())
            self.dotproduct_BE[p].increment(data[1],sample_E[p], shift = self.mean_tot.get_stats())

        
    def _compute_varianceI(self):
        mean_A = self.iterative_shifted_mean_A.get_stats()
        mean_B = self.iterative_shifted_mean_B.get_stats()
        var = np.zeros((self.dimension, self.nb_parms))
        for p in range(self.nb_parms):
            var[:,p] = self.dotproduct_BE[p].get_stats() - mean_A * mean_B
        return var

    def _compute_VTi(self):
        vti = np.zeros((self.dimension, self.nb_parms))
        mean_A = self.iterative_shifted_mean_A.get_stats()
        for p in range(self.nb_parms):
            vti[:,p] = self.var_A.get_stats() - self.dotproduct_AE[p].get_stats() +  mean_A * mean_A
        return vti

    def getSecondOrderIndices(self) -> np.array:
        """
            Compute the self.nb_parms second order sensitivity indices
        """
        raise Exception('Not implemented method')

    def save_state(self):
        """
            An abstract method to implement. It save the current state of the objects.
        """
        state = super().save_state()

        state['dotproduct_AE'] = [self.dotproduct_AE[i].save_state() for i in range(self.nb_parms)]
        state['dotproduct_BE'] = [self.dotproduct_BE[i].save_state() for i in range(self.nb_parms)]

        return state

    def load_from_state(self, state: object):
        """
            It load the current state of the object.
        """
        super().load_from_state(state)

        s = state.get('dotproduct_AE')
        self.dotproduct_AE = [_IterativeDotProduct(self.dimension, iterative_shifted_mean_1 = self.iterative_shifted_mean_A, iterative_shifted_mean_2 = self.iterative_shifted_mean_E[i], state = s[i]) for i in range(self.nb_parms)]
        
        s = state.get('dotproduct_BE')
        self.dotproduct_BE = [_IterativeDotProduct(self.dimension, iterative_shifted_mean_1 = self.iterative_shifted_mean_B, iterative_shifted_mean_2 = self.iterative_shifted_mean_E[i], state = s[i]) for i in range(self.nb_parms)]


class IterativeSobol:
    """
    Iterative Sobol indices.
    
    Parameters
    ----------
    nb_params : int
        Number of parameters of the field
    """
    def __init__(self, nb_parms: int):
        if nb_parms < 2:
            raise ValueError(f"Got {nb_parms} parameters, expected at least 2")
        self._nb_parms = nb_parms
        self._dim = None
        self._size = None
        self._agg_sobol = None

    def increment(self, fields):
        """
        Update data.

        Parameters
        ----------
        fields : List[medcoupling.MEDCouplingFieldDouble]
            List of fields for each pick-freeze combination of the parameters
        """

        if len(fields) != self._nb_parms + 2:
            raise ValueError(f"Got {len(fields)} fields, expected {self._nb_parms + 2}")
        if self._dim == None:
            self._dim = fields[0].getArray().getNumberOfComponents()
            self._size = fields[0].getArray().getNumberOfTuples()
            self._agg_sobol = [_IterativeSensitivitySaltelli(self._nb_parms, dim=self._dim) for k in range(self._size)]

        for k in range(self._size):
            tks = np.array([field.getArray().getTuple(k) for field in fields])
            self._agg_sobol[k].increment(tks.reshape((self._nb_parms + 2,)))

    def indices(self, k):
        """
        Sobol indices accessor.

        Parameters
        ----------
        k : int
            Tuple index in the field

        Returns
        -------
        first, total : np.array
            First and total order Sobol' indices of shape (nb_parms, dim)
        """
        if self._agg_sobol is None:
            raise ValueError("No data aggregated")
        result = self._agg_sobol[k].getFirstOrderIndices(), self._agg_sobol[k].getTotalOrderIndices()
        return result
