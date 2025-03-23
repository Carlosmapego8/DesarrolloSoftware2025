/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mycompany.simulacion;

/**
 *
 * @author cristobalmer
 */
public abstract class Bicicleta {
    protected int id;

    public Bicicleta(int id) {
        this.id = id;
    }

    public int getId() {
        return id;
    }
    
    protected abstract void run();
    protected abstract void die();
}
