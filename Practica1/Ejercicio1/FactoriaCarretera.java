/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mycompany.simulacion;

/**
 *
 * @author cristobalmer
 */
public class FactoriaCarretera implements FactoriaCarreraYBicicleta {
    @Override
    public Carrera crearCarrera(int numBicicletas) {
        return new CarreraCarretera(numBicicletas);
    }

    @Override
    public Bicicleta crearBicicleta(int id) {
        return new BicicletaCarretera(id);
    }
}

