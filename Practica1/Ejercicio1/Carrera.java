/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mycompany.simulacion;

/**
 *
 * @author cristobalmer
 */
import java.util.List;
import java.util.ArrayList;

public abstract class Carrera implements Runnable {
    protected List<Bicicleta> bicicletas;
    protected int duracion = 60; 

    public Carrera(int numBicicletas) {
        bicicletas = new ArrayList<>();
        for (int i = 0; i < numBicicletas; i++) {
            Bicicleta bicicleta = crearBicicleta(i);
            bicicleta.run();
            bicicletas.add(bicicleta);
        }
    }

    protected abstract Bicicleta crearBicicleta(int id);
    protected abstract void retirarBicicletas();

    @Override
    public void run() {
        try {
            Thread.sleep(duracion * 1000);
            retirarBicicletas();
            System.out.println(getClass().getSimpleName() + " finalizada con " + bicicletas.size() + " bicicletas.");
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
    }
}
