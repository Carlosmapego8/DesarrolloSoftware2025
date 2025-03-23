/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mycompany.simulacion;

/**
 *
 * @author cristobalmer
 */
public class CarreraMontana extends Carrera {
    private static final double PORCENTAJE_RETIRO = 0.2; 
    
    public CarreraMontana(int numBicicletas) {
        super(numBicicletas);
    }

    @Override
    protected Bicicleta crearBicicleta(int id) {
        return new BicicletaMontana(id);
    }

    @Override
    protected void retirarBicicletas() {
        int eliminar = (int) (bicicletas.size() * PORCENTAJE_RETIRO);

        for (int i = 0; i < eliminar; i++) {
            bicicletas.get(0).die();
            bicicletas.remove(0);
        }
    }
}
