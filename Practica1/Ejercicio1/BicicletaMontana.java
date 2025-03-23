/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mycompany.simulacion;

/**
 *
 * @author cristobalmer
 */
public class BicicletaMontana extends Bicicleta {
    public BicicletaMontana(int id) {
        super(id);
    }
    
    @Override
    protected void run() {
        System.out.println("Soy una bicicleta de montaña y tengo id: " + id);
    }
    
    @Override
    protected void die() {
        System.out.println("Soy una bicicleta de montaña, tengo id " + id + " y acabo de retirarme");
    }
}