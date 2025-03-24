class DistanceInMiles:
    """Clase que representa la distancia proporcionada por la app de Los Ángeles (en millas)"""
    def __init__(self, miles):
        self.miles = miles

    def get_distance(self):
        return self.miles


class DistanceAdapter:
    """Adaptador que convierte millas a kilómetros."""
    MILES_TO_KM = 1.60934

    def __init__(self, distance_in_miles):
        self.distance_in_miles = distance_in_miles

    def get_distance(self):
        return self.distance_in_miles.get_distance() * self.MILES_TO_KM
