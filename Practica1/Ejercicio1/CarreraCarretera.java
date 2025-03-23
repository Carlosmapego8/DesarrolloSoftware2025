/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mycompany.simulacion;

/**
 *
 * @author cristobalmer
 */
public class CarreraCarretera extends Carrera {
    private static final double PORCENTAJE_RETIRO = 0.1; 

    public CarreraCarretera(int numBicicletas) {
        super(numBicicletas);
    }

    @Override
    protected Bicicleta crearBicicleta(int id) {
        return new BicicletaCarretera(id);
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
