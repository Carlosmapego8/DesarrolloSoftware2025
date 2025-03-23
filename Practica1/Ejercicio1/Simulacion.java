/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 */

package com.mycompany.simulacion;

/**
 *
 * @author cristobalmer
 */
public class Simulacion {
    public static void main(String[] args) {
        int N = (int) (Math.random() * 50) + 1; 
        
        FactoriaCarreraYBicicleta factoriaMontana = new FactoriaMontana();
        FactoriaCarreraYBicicleta factoriaCarretera = new FactoriaCarretera();
        
        Carrera carreraMontana = factoriaMontana.crearCarrera(N);
        Carrera carreraCarretera = factoriaCarretera.crearCarrera(N);

        Thread hiloMontana = new Thread(carreraMontana);
        Thread hiloCarretera = new Thread(carreraCarretera);
        
        hiloMontana.start();
        hiloCarretera.start();
    }
}
