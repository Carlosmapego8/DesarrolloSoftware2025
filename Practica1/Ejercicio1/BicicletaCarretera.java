/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mycompany.simulacion;

/**
 *
 * @author cristobalmer
 */
public class BicicletaCarretera extends Bicicleta {
    public BicicletaCarretera(int id) {
        super(id);
    }
    
    @Override
    protected void run() {
        System.out.println("Soy una bicicleta de carretera y tengo id " + id);
    }
    
    @Override
    protected void die() {
        System.out.println("Soy una bicicleta de carretera, tengo id " + id + " y acabo de retirarme");
    }
}
